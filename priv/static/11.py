from functools import lru_cache

@lru_cache(maxsize=10**6)
def count_stones(stone, blinks):
    if blinks == 0: 
        return 1
    if stone == "0":
        return count_stones("1", blinks - 1)
    if len(stone) % 2 == 0:
        n = len(stone) // 2
        l, r = str(int(stone[:n])), str(int(stone[n:]))
        return count_stones(l, blinks - 1) + count_stones(r, blinks - 1)
    return count_stones(str(int(stone) * 2024), blinks - 1)
    
stones = ["1117", "0", "8", "21078", "2389032", "142881", "93", "385",]
n_stones = [count_stones(s, 75) for s in stones]
print(sum(n_stones))
