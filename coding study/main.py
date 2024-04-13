import itertools

def is_valid_group(group, last_month_groups):
    for last_group in last_month_groups:
        if any(person in last_group for person in group):
            return False
    return True

def find_valid_groups(people, group_size, last_month_groups, current_month_groups=[], valid_groups=[]):
    if len(current_month_groups) == group_size:
        valid_groups.append(current_month_groups.copy())
        return
    
    for i, person in enumerate(people):
        if person not in current_month_groups:
            # 현재 인원이 지난 달 팀과 겹치지 않는지 확인
            if is_valid_group(current_month_groups + [person], last_month_groups):
                current_month_groups.append(person)
                find_valid_groups(people, group_size, last_month_groups, current_month_groups, valid_groups)
                current_month_groups.pop()

def main():
    # 16명의 사람 리스트
    members = ['최동철', '최화수', '정인영', '이혜순', '이창오', '박문환', '정낙균', '정순식', '박창환', '한석환', '조영철', '박채현', '도상원','정연규', '정강현', '김종현']

    # 4명씩 4개의 조로 편성
    group_size = 4
    total_groups = 4

    # 지난 달의 팀 정보
    last_month_groups = [
        ['최동철', '최화수', '정인영', '이혜순'],
        ['이창오', '박문환', '정낙균', '정순식'],
        ['박창환', '한석환', '조영철', '박채현'],
        ['도상원', '정연규', '정강현', '김종현']
    ]

    # 가능한 모든 조합 탐색
    valid_groups = []
    find_valid_groups(members, group_size, last_month_groups, [], valid_groups)

    # 결과 출력
    for idx, group in enumerate(valid_groups):
        print(f'Month {idx + 1}: {", ".join(group)}')

if __name__ == "__main__":
    main()
