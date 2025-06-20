/*
 * FULLTRAP_NATIVE.CPP - Scans root processes, suspends suspicious ones, logs PIDs, and dumps their executable paths.
 */

#include <Windows.h>
#include <TlHelp32.h>
#include <psapi.h>
#include <stdio.h>
#include <wchar.h>

#define SLEEP_INTERVAL_MS 100
#define MAX_DUMP_COUNT 50
#define WHITELIST_COUNT 8

const char* WHITELIST[WHITELIST_COUNT] = {
    "System Idle Process", "System", "csrss.exe",
    "smss.exe", "wininit.exe", "winlogon.exe", "services.exe", "lsass.exe"
};

int is_whitelisted(const char* procName) {
    for (int i = 0; i < WHITELIST_COUNT; ++i) {
        if (_stricmp(procName, WHITELIST[i]) == 0)
            return 1;
    }
    return 0;
}

DWORD get_parent_pid(DWORD pid) {
    HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnap == INVALID_HANDLE_VALUE) return 0;

    PROCESSENTRY32 pe;
    pe.dwSize = sizeof(PROCESSENTRY32);

    DWORD ppid = 0;
    if (Process32First(hSnap, &pe)) {
        do {
            if (pe.th32ProcessID == pid) {
                ppid = pe.th32ParentProcessID;
                break;
            }
        } while (Process32Next(hSnap, &pe));
    }
    CloseHandle(hSnap);
    return ppid;
}

void log_frozen_pid(const char* procName, DWORD pid, const char* exePath) {
    FILE* f = fopen("frozen_pids.txt", "a");
    if (f) {
        SYSTEMTIME st;
        GetLocalTime(&st);
        fprintf(f, "%04d-%02d-%02d %02d:%02d:%02d.%03d;%s;PID=%lu;%s\n",
            st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond, st.wMilliseconds,
            procName, pid, exePath ? exePath : "");
        fclose(f);
    }
}

void monitor_and_suspend() {
    int dumpCount = 0;
    while (dumpCount < MAX_DUMP_COUNT) {
        HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (hSnap == INVALID_HANDLE_VALUE) continue;

        PROCESSENTRY32 pe;
        pe.dwSize = sizeof(PROCESSENTRY32);

        if (Process32First(hSnap, &pe)) {
            do {
                // Konwersja nazwy procesu do ANSI jeśli UNICODE, w przeciwnym razie kopiuj bezpośrednio
                char procNameA[MAX_PATH];
            #ifdef UNICODE
                WideCharToMultiByte(CP_ACP, 0, pe.szExeFile, -1, procNameA, MAX_PATH, NULL, NULL);
            #else
                strcpy(procNameA, pe.szExeFile);
            #endif

                if (is_whitelisted(procNameA)) continue;

                DWORD ppid = get_parent_pid(pe.th32ProcessID);
                if (ppid != 0) continue; // only root processes

                HANDLE hProc = OpenProcess(PROCESS_ALL_ACCESS, FALSE, pe.th32ProcessID);
                if (hProc) {
                    char exePath[MAX_PATH] = {0};
                    if (!GetModuleFileNameExA(hProc, NULL, exePath, MAX_PATH) || exePath[0] == '\0') {
                        strcpy(exePath, "unknown");
                    }

                    printf("[!] Suspending: %s (PID: %lu)\n", procNameA, pe.th32ProcessID);

                    // Suspend all threads of the process
                    HANDLE hThreadSnap = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
                    if (hThreadSnap != INVALID_HANDLE_VALUE) {
                        THREADENTRY32 te;
                        te.dwSize = sizeof(THREADENTRY32);

                        if (Thread32First(hThreadSnap, &te)) {
                            do {
                                if (te.th32OwnerProcessID == pe.th32ProcessID) {
                                    HANDLE hThread = OpenThread(THREAD_SUSPEND_RESUME, FALSE, te.th32ThreadID);
                                    if (hThread) {
                                        SuspendThread(hThread);
                                        CloseHandle(hThread);
                                    }
                                }
                            } while (Thread32Next(hThreadSnap, &te));
                        }
                        CloseHandle(hThreadSnap);
                    }

                    log_frozen_pid(procNameA, pe.th32ProcessID, exePath);
                    CloseHandle(hProc);
                    dumpCount++;
                }
            } while (Process32Next(hSnap, &pe));
        }
        CloseHandle(hSnap);
        Sleep(SLEEP_INTERVAL_MS);
    }
}

int main() {
    printf("[FULLTRAP_NATIVE] Started...\n");
    monitor_and_suspend();
    printf("[FULLTRAP_NATIVE] Finished.\n");
}