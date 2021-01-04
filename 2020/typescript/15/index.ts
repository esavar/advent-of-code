// Puzzle input 19,20,14,0,9,1 

const nthSpoken = (n: number) => {
  const input = new Map<number, Record<string, number[]>>()
  input.set(19, {indices: [1]})
  input.set(20, {indices: [2]})
  input.set(14, {indices: [3]})
  input.set(0, {indices: [4]})
  input.set(9, {indices: [5]})
  input.set(1, {indices: [6]})

  let spoken = 1
  let spokenBefore: Record<string, number[]> | undefined = undefined
  let hasBeenSpoken = false
  for (let i: number = (input.size + 1); i<=n; i++) {
    if (hasBeenSpoken) {
      spoken = spokenBefore ? spokenBefore.indices[1] - spokenBefore['indices'][0] : 0
      spokenBefore = input.get(spoken)
      if (!spokenBefore) {
        hasBeenSpoken = false
      } else {
        hasBeenSpoken = true
      }
      input.set(spoken, {indices: spokenBefore ? spokenBefore.indices.length > 1 ? [spokenBefore.indices[1], i] : [spokenBefore.indices[0], i] : [i]})
    } else {
      spoken = 0
      spokenBefore = input.get(spoken)
      if (!spokenBefore) {
        hasBeenSpoken = false
      } else {
        hasBeenSpoken = true
      }
      input.set(0, {indices: spokenBefore ? spokenBefore.indices.length > 1 ? [spokenBefore.indices[1], i] : [spokenBefore.indices[0], i] : [i]})
    }
    spokenBefore = input.get(spoken)
    if (i % 1000000 === 0) console.log(`${i} ${spoken}`)
  }
  return spoken
}

console.log(`Part 1: ${nthSpoken(2020)}`)
console.log(`Part 2: ${nthSpoken(30000000)}`)
