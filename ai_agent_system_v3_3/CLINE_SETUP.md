# CLINE_SETUP.md — Cline 설정 가이드 (v3.0.1)
> Cline의 Custom Instructions는 폐기되었습니다.
> 현재 버전 기준 설정 방법을 안내합니다.

---

## 현재 Cline Rules 구조

```
Cline Rules
  ├── Global Rules   ← 저울(⚖️) 아이콘 → 모든 프로젝트에 공통 적용
  └── Workspace Rules
        └── .clinerules ← 프로젝트 루트 파일 → 이 프로젝트에만 자동 적용
```

이 시스템은 **두 레이어를 함께 사용**합니다.

---

## Step 1. Workspace Rules — 자동 적용 (설정 불필요)

`.clinerules` 파일이 프로젝트 루트에 있으면 Cline이 자동으로 읽습니다.

```
내 프로젝트/
  ├── .clinerules   ← ✅ 여기 있으면 자동 적용
  ├── .ai_checkpoints/
  └── ai/
```

**확인 방법**: Cline 채팅창 하단 저울(⚖️) 아이콘 클릭 → Workspace Rules 탭에 `.clinerules` 항목이 보이면 정상.

---

## Step 2. Global Rules — 에이전트 페르소나 등록

`ai/System_Prompt.md`의 내용을 Global Rules에 등록하면,
이 프로젝트 외의 다른 작업에서도 동일한 에이전트 행동 방식이 유지됩니다.

### 등록 방법

1. Cline 채팅창 하단 **저울(⚖️) 아이콘** 클릭
2. **Global Rules** 탭 선택
3. `ai/System_Prompt.md` 파일을 열고 `---` 아래 내용 전체를 복사
4. Global Rules 입력창에 붙여넣고 저장

### 이 프로젝트에만 쓴다면?

Global Rules 등록은 **선택사항**입니다.
`.clinerules`만으로 이 시스템의 모든 규칙이 적용됩니다.

---

## 두 레이어의 역할 분담

| 레이어 | 파일 | 담당 내용 | 적용 범위 |
|--------|------|-----------|-----------|
| Workspace | `.clinerules` | 안전 규칙, Risk 판정, 백업/롤백 방식, 작업 유형별 동작 | 이 프로젝트만 |
| Global | `ai/System_Prompt.md` | 에이전트 페르소나, 커뮤니케이션 스타일, 보고 형식 | 모든 프로젝트 |

> 충돌 시: Workspace Rules(`.clinerules`)가 우선합니다.

---

## 과거 Custom Instructions 사용자

이전에 설정창에 입력해두었던 내용은 Cline 업데이트 시
**Global Rules 디렉터리로 자동 마이그레이션**되었습니다.

확인: 저울(⚖️) 아이콘 → Global Rules 탭에서 기존 내용 확인 가능.

기존 내용이 있다면 이 시스템의 `ai/System_Prompt.md` 내용으로 **교체**하는 것을 권장합니다.

---

## 빠른 확인 체크리스트

```
[ ] .clinerules 파일이 프로젝트 루트에 있음
[ ] 저울 아이콘 → Workspace Rules에 .clinerules 항목 확인
[ ] (선택) Global Rules에 System_Prompt.md 내용 등록
[ ] ai/Context_Profile.md에서 ACTIVE_PROFILE 값 확인 (WORK/HOBBY)
[ ] Mac: chmod +x ai/scripts/backup.sh ai/scripts/archive_log.sh
[ ] 회사 Windows: Git Bash에서 동일하게 bash ai/scripts/backup.sh 사용
```
