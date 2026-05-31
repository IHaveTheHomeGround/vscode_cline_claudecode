# AI Agent Execution System — v3.0
> VSCode + Cline | No-Git | Local Enterprise

## 한 줄 요약

> 자율 실행 중심의 로컬 AI 에이전트 백본.  
> CRITICAL만 승인 요청, 나머지는 알아서 처리하고 완료 후 보고.

---

## 설치 (5분)

### 1. 이 폴더를 프로젝트 루트에 복사
```
프로젝트/
  ├── .clinerules          ← 여기 있어야 Cline이 자동으로 읽음
  ├── .ai_checkpoints/
  └── ai/
```

### 2. Cline Rules 설정 (업데이트된 방법)

> ⚠️ Cline이 업데이트되면서 **Custom Instructions 설정창이 폐기**되었습니다.  
> 현재는 **Rules 시스템** 두 가지 방법을 사용합니다.

#### 방법 A — `.clinerules` 파일 (이미 포함됨 ✓ — 권장)
이 시스템에 포함된 `.clinerules`가 **프로젝트 루트에 있으면 Cline이 자동으로 읽습니다.**  
별도 설정 없이 Step 1만 완료하면 프로젝트 단위 규칙은 자동 적용됩니다.

#### 방법 B — Global Rules (저울 아이콘) — System_Prompt 등록
에이전트의 **페르소나와 행동 강령**(`ai/System_Prompt.md`)을 모든 프로젝트에 공통 적용하려면:

1. Cline 채팅창 하단 입력창 근처의 **저울(⚖️) 아이콘** 클릭
2. 팝업에서 **Global Rules** 탭 선택
3. `ai/System_Prompt.md` 파일의 내용을 붙여넣고 저장

> 💡 **어떤 것을 Global에 넣어야 하나요?**  
> - **`.clinerules`** → 현재 프로젝트 전용 규칙 (자동 적용, 추가 설정 불필요)  
> - **`ai/System_Prompt.md`** → 에이전트 페르소나 (모든 프로젝트에 공통 적용할 때 Global에 등록)  
> 업무 프로젝트 하나에만 쓴다면 `.clinerules`만으로 충분합니다.

### 3. 스크립트 실행 권한 부여 (Mac/Linux만)
```bash
chmod +x ai/scripts/backup.sh
chmod +x ai/scripts/archive_log.sh
```

### 4. 현재 모드 확인
`ai/Context_Profile.md` 열어서 `ACTIVE_PROFILE` 값 확인  
기본값: WORK

---

## 사용 흐름

```
사용자 요청
  │
  ├─ LIGHTWEIGHT/STANDARD → 에이전트가 알아서 처리 → 완료 보고
  │
  └─ CRITICAL             → 에이전트가 계획 제시 → 승인 → 처리 → 완료 보고
```

**Cline 자동 동작**:
- 세션 시작 시 `.clinerules` 자동 로드
- STANDARD 이상 작업 전 `bash ai/scripts/backup.sh` 자동 실행
- 완료 후 `.ai_checkpoints/WORK_LOG.md`에 자동 기록

---

## 파일 구조

```
ai_agent_system_v3/
├── .clinerules                    ← Cline 자동 로드 핵심 규칙
├── README.md                      ← 이 파일
├── Claude_history.md              ← 설계 이력
├── ChatGPT_history2.md            ← 이전 평가 이력
├── ai/
│   ├── System_Prompt.md           ← Global Rules(저울 아이콘)에 등록 (선택)
│   ├── Core_System.md             ← 상태 머신 정의
│   ├── Risk_Matrix.md             ← Risk 판정 기준
│   ├── Context_Profile.md         ← WORK / HOBBY 모드 전환
│   ├── PROJECT_START.md           ← 에이전트 초기화 절차
│   ├── scripts/
│   │   ├── backup.sh              ← 백업 + SHA256 해시 (Mac Terminal & 회사 Git Bash 공통)
│   │   └── archive_log.sh         ← WORK_LOG 아카이브 (Mac Terminal & 회사 Git Bash 공통)
│   └── templates/
│       ├── CHECKPOINT_TEMPLATE.md ← 체크포인트 양식 (SHA256 포함)
│       ├── VALIDATION_CONTRACT.md ← 검증 계약 양식 (유형별 가이드)
│       └── WORK_LOG_TEMPLATE.md   ← 작업 이력 양식
└── .ai_checkpoints/
    ├── KEEP_THIS_FOLDER.txt
    ├── WORK_LOG.md                ← 자동 생성
    └── archive/                   ← 50KB 초과 시 자동 아카이브
```

---

## 자주 쓰는 명령어

> **Mac Terminal과 회사 Git Bash 모두 동일한 명령어를 사용합니다.**

```bash
# 수동 백업 (STANDARD 이상 작업 전)
bash ai/scripts/backup.sh src/main.py config/settings.json

# WORK_LOG 아카이브 (50KB 초과 또는 강제 실행)
bash ai/scripts/archive_log.sh
bash ai/scripts/archive_log.sh --force

# 롤백
cp ".ai_checkpoints/20260530_1430/main.py.bak" "src/main.py"

# 무결성 확인
shasum -a 256 src/main.py
```

---

## 버전 이력

| 버전 | 변경 내용 |
|------|-----------|
| v2.8 | Validation Contract, Risk Matrix 도입 |
| v2.9 | 명세 완결성 강화, 템플릿 제공 |
| v2.9.1 | No-Git 환경 완전 정비, git 잔재 제거 |
| v3.0 | 처음부터 재설계. VSCode+Cline 전용. 자율 실행 중심. 백업 스크립트(SHA256), WORK_LOG 아카이브 내장. |
| v3.0.1 | Cline Rules 시스템 업데이트 반영 (Custom Instructions 폐기 → .clinerules + Global Rules). |
| v3.0.2 | Mac(집/HOBBY) + Windows 10(회사/WORK) 듀얼 환경 대응. backup.bat·archive_log.bat의 wmic 제거 → PowerShell로 교체. 검증 명령어 Mac/Windows 병기. |
| **v3.0.3** | **회사 PowerShell 사용 불가 확인. .bat 삭제. Git Bash로 통일 → Mac Terminal과 동일한 .sh 스크립트 사용. 명령어 체계 단순화.** |
