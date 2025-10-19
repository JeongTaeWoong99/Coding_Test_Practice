**📅 작성일**: 2025-10-04

## 🔗 문제 링크
[Attribute Parser(속성 파서)](https://www.hackerrank.com/challenges/attribute-parser/problem?isFullScreen=true)

---

## 🤔 접근법

마크다운 형식의 태그와 속성을 파싱하여, 쿼리에 따라 특정 태그의 속성 값을 출력하는 구현 파싱 문제.

문제가 이해되지 않아서, 방향 잡는게 쉽지 않았음.

다음에 다시 도전 예정.

## `💡 정답 풀이 방법`

### 📌 핵심 아이디어

1. **태그 계층 구조 관리**
   - `vector<string> tagStack` 사용하여 현재 태그 경로 추적
   - 여는 태그는 스택에 추가, 닫는 태그는 스택에서 제거

2. **속성 저장 방식**
   - `map<string, string>` 사용
   - 키: `태그경로~속성명` (예: `tag1.tag2.tag3~attr`)
   - 값: 속성 값

3. **파싱 전략**
   - `stringstream`을 사용하여 각 라인을 토큰 단위로 파싱
   - 닫는 태그(`</tag>`)와 여는 태그(`<tag>`) 구분
   - 속성은 `=` 기준으로 이름과 값 분리
   - 따옴표와 특수문자 제거

4. **쿼리 처리**
   - 쿼리 형식: `tag1.tag2~attribute`
   - `map`에서 O(log n) 시간에 검색
   - 존재하면 값 출력, 없으면 "Not Found!" 출력

### ⚙️ 시간 복잡도

- **파싱**: O(n × m) (n: 라인 수, m: 평균 토큰 수)
- **쿼리**: O(q × log n) (q: 쿼리 수)
- **전체**: O(n × m + q × log n)

### 🔍 주요 구현 포인트

1. **태그 경로 생성**
   ```cpp
   string fullPath = "";
   for(int j = 0; j < tagStack.size(); j++)
   {
       if(j > 0) fullPath += ".";
       fullPath += tagStack[j];
   }
   ```

2. **속성 파싱**
   - `attr = value` 형식에서 따옴표 제거
   - `>` 문자로 태그 끝 감지

3. **맵 저장**
   - `fullPath + "~" + attr` 형식으로 키 생성
   - 구분자 `~` 사용 (`.`은 태그 경로에 사용됨)