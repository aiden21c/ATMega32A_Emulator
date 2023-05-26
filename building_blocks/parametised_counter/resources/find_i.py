def find_i(x):
  # takes in a number x
  # loops down from a value of 31
  for i in range(31, -1, -1):
    # if x is greater than 2^i - 1
    if x > (2**i) - 1:
      # break and return the value i + 1
      return i + 1
  # if no i satisfies the condition, return None
  return None

# test the function with some examples
print(find_i(0.78125)) # should print 18
