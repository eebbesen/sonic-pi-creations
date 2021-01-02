# provides incrment for linear progression
# from span to target value
def coalesce_to_tempo(target, span, start = [0,1])
  low = start[0]
  high = start[1]

  (target - (high - low)).abs / span
end
