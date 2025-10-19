#include <iostream>
#include <vector>
#include <map>
#include <sstream>
#include <algorithm>
using namespace std;

int n,q; // n: HRML 줄 수, q: 질의 수

vector<string>      hrml;    // HRML 원문 라인들
vector<string>      quer;    // 질의 문자열들
map<string, string> m;       // "경로~속성" -> "값"
vector<string>      channel; // 현재 경로 스택(누적 경로 문자열 저장) => tag1 tag1.tga2 tag1.tag2.tag3

int main() 
{
    cin >> n >> q;
    cin.ignore(); // ★ \n 제거 
    
    // HRML 넣기
    for (int i = 0; i < n; i++) 
    {
        string temp;
        getline(cin, temp);
        hrml.push_back(temp);
    }

    // quer 넣기
    for (int i = 0; i < q; i++) 
    {
        string temp;
        getline(cin, temp);
        quer.push_back(temp);
    }

    // HRML 파싱
    for (int i = 0; i < n; i++) 
    {
        string temp = hrml[i];
        
        // 파싱 편의를 위해 불필요 문자 제거 : " 와 >
        temp.erase(remove(temp.begin(), temp.end(), '"'), temp.end());
        temp.erase(remove(temp.begin(), temp.end(), '>'), temp.end());
        
        // 닫는 태그인지 확인: "</"
        // 현재 경로 변경
        if (temp.substr(0, 2) == "</") 
        {
            channel.pop_back();   // 경로에서 한 단계 위로
        }
        // 여는 태그 라인: 예) <tag1 value = HelloWorld 
        else 
        {
            // 공백 단위 토큰으로 쉽게 파싱하려고 stringstream을 사용
            stringstream ss;
            ss.str(temp);
						
            string t1, p1, v1; // t1=태그명, p1=속성명, v1=속성값
            char ch;           // '<' 또는 '=' 등 구분자 흡수 제거용

            // stringstream ss의 >>를 이용하면, 공백 단위 파싱 가능!!!
            // 최소 1개 속성이 있다고 가정하고 첫 속성까지 읽음
            // <tag1 value = HelloWorld 에서 char 크기의 '<'와 '='는 흡수 제거
            // t1:tag1, p1:value, v1:HelloWorld 저장 사용
            ss >> ch >> t1 >> p1 >> ch >> v1;
            
            // 누적 경로 만들기(닫히기 전까지 절대경로 유지)
            string tempChannel;
            if (!channel.empty()) 
            {
                tempChannel = channel.back(); // 현재까지의 누적 경로(마지막 원소 하나)
                tempChannel += "." + t1;      // 부모경로 + "." + 현재 태그
            } 
            else 
            {
                tempChannel = t1; // 루트 태그
            }

            channel.push_back(tempChannel); // 새 경로를 스택에 push
						
            // 첫 속성 저장: "경로~속성명" -> 값
            m[channel.back() + "~" + p1] = v1;

            // 남은 속성들 반복 저장 (공백 구분 기반)
            // 예) p2 = v2, p3 = v3 ...
            while (ss) 
            {
                ss >> p1 >> ch >> v1; // p1, '=', v1 순으로 읽힘
                if (!ss) 
                    break;            // 실패 시 탈출(예방)
                m[channel.back() + "~" + p1] = v1; // N번째 속성들 저장
            }
        }
    }

    // 질의 처리: 맵 조회
    for (int i = 0; i < q; i++) 
    {
        // map에 없음
        if (m.find(quer[i]) == m.end()) cout << "Not Found!\n";
        // map에 있음
        else cout << m[quer[i]] << '\n';
    }

    return 0;
}