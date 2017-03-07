from minEditAlign import *
timing_2 = [[1,3],[4,7],[8,10],[11,14]]
timing_1 = [[4,5],[6,8],[9,14],[15,17],[18,20]]
word_2 = ["jo", "lo", "po","mo"]
word_1 = ["jo", "po","mo","to","ro"]

word_2 = ["I", "am", "not","mean"]
word_1 = ["I", "am","mean","and","gross"]

D, B = wagner_fischer(word_1, word_2, timing_1, timing_2)
bt = naive_backtrace(B)
	 
scores_2 = [0.7, 0.2, 0.7,1.0]
scores_1 = [0.1,0.8,0.6,1.0,0.6]
none_score = 0.2
alignment_table = align(word_1, word_2, bt, timing_1, timing_2, scores_1, scores_2, none_score, 0.5)
print alignment_table

([' ', 'I', 'am', ' ', 'mean', 'and', 'gross'], ['I', ' ', 'am', 'not', 'mean', ' ', ' '], ['i', 'd', ' ', 'i', ' ', 'd', 'd'], [[1, 3], [4, 5], [6, 8], [8, 10], [9, 14], [15, 17], [18, 20]], [0.2, 0.05, 0.5, 0.2, 0.8, 0.5, 0.3], [0.35, 0.2, 0.5, 0.35, 0.8, 0.2, 0.2], {'score': [0.35, 0.2, 0.5, 0.35, 0.8, 0.5, 0.3], 'seq': ['I', '!NULL', 'am', 'not', 'mean', 'and', 'gross']})

