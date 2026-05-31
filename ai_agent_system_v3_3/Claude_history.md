# Claude_history.md — v3.0
> 작성: Claude Sonnet 4.6 (Anthropic)
> 작성일: 2026-05-30
> 내용: v2.x 계열 평가 요약 + v3.0 처음부터 재설계 근거 및 내역

---

## 사용자 환경 (모든 버전에서 유지해야 할 전제)

| 항목 | 내용 |
|------|------|
| 에이전트 도구 | VSCode + Cline + Claude Code |
| Git 사용 여부 | **미사용** (학습 계획 없음) |
| 사용 환경 | 회사 컴퓨터 (업무) + 개인 (취미) |
| 주요 작업 | 코드 작성/리팩토링, 문서 작성/정리, 파일 분석/데이터 처리, 자동화 스크립트 |
| 개입 방식 | CRITICAL만 승인 요청, 나머지는 자율 실행 |
| 버전 관리 | `.ai_checkpoints/` 파일 복사 방식 (Git 대체) |
| 롤백 방식 | `cp` / `copy` 명령어로 `.bak` 파일 복원 |

---

## v2.x 계열 평가 요약

### v2.8 평가 (Claude 기준: 67/100)
- 개념 설계는 우수하나 실제 실행 가능성 부족
- PROJECT_START.md 내용 없음, System_Prompt.md 4줄
- 상태 전이 조건 미정의, 템플릿 전무

### v2.9 개선 (명세 완결성)
- 상태 전이 조건, 템플릿 3종, Context Profile, Risk Matrix 추가
- 구조적 문제: v2.8을 패치한 형태 — 처음부터 설계했다면 두지 않을 구조 잔존

### v2.9.1 개선 (No-Git 환경 대응)
- .gitkeep → KEEP_THIS_FOLDER.txt
- git stash 등 Git 명령어 잔재 완전 제거
- Windows/Mac·Linux 롤백 명령어 병기

### Gemini(박구) 평가 v2.9.1: 96/100
- 강점 평가는 정확. 점수는 다소 관대 (Claude 기준 실제 85점 수준)
- 유효한 개선 제안 3가지:
  1. 백업 자동화 스크립트
  2. SHA256 무결성 검증
  3. WORK_LOG 아카이브 규칙

---

## v3.0 재설계 근거

### 왜 패치가 아닌 처음부터?

v2.x는 "타인이 설계한 시스템을 점진적으로 패치"한 구조.  
집에 방을 계속 추가하면 처음부터 설계한 집보다 구조적으로 불리하다.

v3.0 시점에서 사용자 환경 정보가 충분히 확보됨:
- VSCode + Cline 전용 (`.clinerules` 자동 로드 활용 가능)
- 4가지 작업 유형 명확
- 자율 실행 중심 (CRITICAL만 승인)
- No-Git 확정

이 정보를 처음부터 반영한 설계가 패치 누적보다 정합성이 높다.

---

## v3.0 설계 원칙 및 내역

### 핵심 원칙
1. **자율 실행 우선**: CRITICAL 이외는 묻지 않고 실행. 판단 근거는 완료 보고에 포함.
2. **Cline 특성 활용**: `.clinerules` 자동 로드를 핵심 인터페이스로 사용.
3. **작업 유형 명세**: CODE / DOC / ANALYSIS / SCRIPT 4가지 유형별 행동 정의.
4. **박구 제안 내장**: 백업 스크립트, SHA256 검증, WORK_LOG 아카이브를 처음부터 포함.

### 파일별 설계 결정

| 파일 | 설계 결정 |
|------|-----------|
| `.clinerules` | 핵심 규칙만 간결하게. Cline이 읽는 유일한 자동 로드 파일. |
| `System_Prompt.md` | Cline Custom Instructions에 직접 붙여넣는 완전한 프롬프트. |
| `Core_System.md` | 상태 머신을 7단계→6단계로 단순화. 각 상태 진입/탈출 조건 완전 정의. |
| `Risk_Matrix.md` | 작업 유형별(CODE/DOC/ANALYSIS/SCRIPT) 예시 추가. |
| `Context_Profile.md` | WORK/HOBBY 프로파일 표 형식으로 명확화. |
| `PROJECT_START.md` | WORK_LOG 아카이브 규칙 포함. |
| `backup.sh/bat` | **신규**: SHA256 해시 자동 기록 + CHECKPOINT.md 초안 자동 생성. |
| `archive_log.sh/bat` | **신규**: 50KB 임계값 기반 자동 아카이브. --force 옵션 지원. |
| `CHECKPOINT_TEMPLATE.md` | SHA256 해시 필드 추가. OS별 명령어 병기. |
| `VALIDATION_CONTRACT.md` | 작업 유형별 검증 방법 가이드 추가. |

### v2.x 대비 제거한 것
- QA_CRITIQUE 단계: 자율 실행 원칙과 충돌. VERIFY 단계로 통합.
- APPROVAL_GATE 별도 상태: GATE로 통합하여 단순화.
- WORK_LOG_ENTRY 별도 상태: REPORT_OK 후 LOG로 통합.

---

## 향후 개선 권고 (v3.x)

| 항목 | 설명 | 우선순위 |
|------|------|----------|
| rollback.sh/bat | 체크포인트 ID 지정 시 자동 롤백 + 무결성 확인 스크립트 | 높음 |
| 체크포인트 정리 스크립트 | 만료된 체크포인트 목록 표시 (삭제는 사람 승인) | 중간 |
| Persona Mode 확장 | 연구/디버깅/배포 등 추가 프로파일 | 낮음 |
| MCP 연동 정책 | 외부 도구 연동 시 Risk 판정 가이드 | 낮음 |

---

## v3.0.1 패치 — Cline Rules 시스템 대응

### 패치 배경

Cline이 업데이트되면서 **Custom Instructions 설정창이 폐기**되고
**Rules 시스템(Workspace Rules + Global Rules)** 으로 통합됨.

| 변경 전 (구버전) | 변경 후 (현재) |
|---|---|
| VSCode → Cline 설정 → Custom Instructions 텍스트창 | 폐기됨 |
| — | `.clinerules` → Workspace Rules (프로젝트 루트, 자동 적용) |
| — | 저울(⚖️) 아이콘 → Global Rules (모든 프로젝트 공통) |

### 수정 파일

| 파일 | 변경 내용 |
|------|-----------|
| `README.md` | 설치 Step 2 전면 교체. 새로운 Rules 시스템 두 가지 방법 안내. |
| `ai/System_Prompt.md` | 상단 사용법 주석 교체. Global Rules 등록 방법으로 업데이트. |
| `CLINE_SETUP.md` | **신규 추가**. Workspace/Global Rules 구조, 역할 분담, 설정 체크리스트 포함. |

### 설계 판단

- `.clinerules`는 이미 Workspace Rules 방식으로 동작하고 있었으므로 **내용 변경 없음**.
- `System_Prompt.md`는 이제 Global Rules에 등록하는 용도. 내용(규칙) 자체는 변경 없이 안내 주석만 교체.
- `CLINE_SETUP.md`를 별도 파일로 분리한 이유: README.md가 길어지는 것을 방지하고, 설치 시 가장 먼저 참고할 파일을 명확히 구분.

---

## v3.0.2 패치 — Mac(집) + Windows 10(회사) 듀얼 환경 대응

### 패치 배경

사용자 환경 추가 확인:
- **집**: Mac — 취미/개인 프로젝트 → HOBBY 프로파일
- **회사**: Windows 10 — 업무 → WORK 프로파일

파일 검토 결과, 실질적 버그 1건 + 개선 2건 발견.

### 수정 내역

| 파일 | 문제 | 수정 |
|------|------|------|
| `backup.bat` | `wmic os get localdatetime` — Windows 10에서 deprecated, 향후 제거 예정. 타임스탬프/해시 파싱 불안정 | PowerShell `Get-Date`, `Get-FileHash`로 완전 교체 |
| `archive_log.bat` | 동일하게 `wmic` 사용 | PowerShell `Get-Date`, `Get-Item` 으로 교체 |
| `VALIDATION_CONTRACT.md` | 검증 명령어가 Mac(bash) 기준만 있음 | DOC/ANALYSIS/SCRIPT 섹션에 Windows PowerShell 명령어 병기 |
| `Context_Profile.md` | 환경-프로파일 매핑 미명시 | 상단에 Mac=HOBBY, Windows=WORK 매핑 표 추가 |
| `README.md` | Windows 무결성 확인이 `certutil` 방식 | `Get-FileHash` PowerShell 방식으로 업데이트 |

### 변경하지 않은 것과 이유

| 파일 | 이유 |
|------|------|
| `.clinerules` | OS 무관한 규칙만 담고 있음 — 그대로 사용 가능 |
| `backup.sh`, `archive_log.sh` | Mac 전용 bash 스크립트 — 변경 불필요 |
| `Core_System.md`, `Risk_Matrix.md` | OS 무관 — 그대로 사용 가능 |
| `CHECKPOINT_TEMPLATE.md` | Windows/Mac 명령어 이미 병기됨 — 추가 수정 불필요 |

### 실사용 가이드 (요약)

```
회사 (Windows 10):
  - ACTIVE_PROFILE: WORK 확인
  - 백업: ai\scripts\backup.bat 사용
  - 아카이브: ai\scripts\archive_log.bat 사용

집 (Mac):
  - ACTIVE_PROFILE: HOBBY 로 변경 (또는 "취미 모드" 요청)
  - 백업: bash ai/scripts/backup.sh 사용
  - 아카이브: bash ai/scripts/archive_log.sh 사용
```

---

## v3.0.3 패치 — Git Bash 통일 (PowerShell 사용 불가 대응)

### 패치 배경

추가 확인된 사용자 환경:
- 회사 Windows 10: **PowerShell 사용 불가** (회사 정책)
- 회사 Windows 10: **Git Bash 사용 가능**

v3.0.2에서 `wmic` 문제를 해결하려고 PowerShell로 교체했으나,
그 PowerShell 자체가 회사 환경에서 막혀 있는 상황.

### 핵심 결정: .bat 파일 전면 폐기, Git Bash로 통일

Git Bash가 있으면 Mac Terminal과 동일한 `.sh` 스크립트를 사용할 수 있음.
이를 활용하면 오히려 더 단순한 구조가 됨:

```
Mac Terminal:  bash ai/scripts/backup.sh ...
회사 Git Bash: bash ai/scripts/backup.sh ...   ← 완전히 동일
```

### 수정 내역

| 파일/항목 | 변경 |
|-----------|------|
| `backup.bat` | **삭제** |
| `archive_log.bat` | **삭제** |
| `.clinerules` | `.bat` 언급 제거, `bash backup.sh (Git Bash)` 로 통일 |
| `Context_Profile.md` | 스크립트 항목 `.bat` → `bash backup.sh (Git Bash)` |
| `VALIDATION_CONTRACT.md` | 검증 가이드 Mac/PowerShell 병기 → Git Bash 통일 단순화 |
| `CHECKPOINT_TEMPLATE.md` | 롤백 절차 Windows/Mac 분리 → Git Bash 통일 단순화 |
| `README.md` | 명령어 섹션에서 Windows batch 블록 제거, Git Bash 단일 블록으로 |
| `CLINE_SETUP.md` | 체크리스트에서 `.bat` 제거, Git Bash 명시 |

### 확정된 사용자 환경 정보 (누적)

| 항목 | 내용 |
|------|------|
| 에이전트 도구 | VSCode + Cline + Claude Code |
| Git 사용 | 미사용 (버전 관리 목적) |
| 집 OS | Mac — HOBBY 프로파일 — bash Terminal |
| 회사 OS | Windows 10 — WORK 프로파일 — Git Bash |
| 회사 제약 | PowerShell 사용 불가, Git 명령어 사용 불가 |
| 스크립트 통일 | `.sh` 파일만 사용 (Mac Terminal & Git Bash 공통) |
