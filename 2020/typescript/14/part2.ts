import { readFileSync } from 'fs'
// import { performance } from 'perf_hooks'

const data = readFileSync('input.txt','utf8').split('\n')

const getMasks = (mask: string): string[] => {
  let j = mask.length
  let addrArr: string[] = []
  let leftMask = ''
  if ((mask.match(/X/g) || []).length === 0) return [mask]
  while (j--) {
    if (mask[j] === 'X') {
      if (addrArr.length === 0) {
        addrArr = addrArr.concat(['0' + mask.substring(j + 1)])
        addrArr = addrArr.concat(['1' + mask.substring(j + 1)])
      } else {
        let tempArr = addrArr
        addrArr = addrArr.map((a) => '0' + leftMask.substring(j + 1) + a)
        tempArr = tempArr.map((a) => '1' + leftMask.substring(j + 1) + a)
        addrArr = addrArr.concat(tempArr)
      }
      leftMask = mask.substring(0, j)
    }
  }
  addrArr = addrArr.map((a) => leftMask + a)
  return addrArr
}

let dataMap = new Map()
let currentMask: string = ''
data.forEach((elem) => {
  if (elem.startsWith('mask')) {
    currentMask = elem.split('=')[1].trim()
  } else if (elem.startsWith('mem')) {
    let addr = parseInt(elem.substring(elem.lastIndexOf('[') + 1, elem.lastIndexOf("]"))).toString(2).padStart(36, '0')
    let i = addr.length
    while (i--) {
      if (currentMask[i] === 'X' || currentMask[i] === '1') {
        addr = addr.substring(0, i) + currentMask[i] + addr.substring(i + 1)
      } 
    }
    // let t0 = performance.now()
    let masks = getMasks(addr)
    // let t1 = performance.now()
    // console.log("Getting masks took " + (t1 - t0) + " milliseconds.")
    let value = parseInt(elem.split('=')[1].trim())
    let addrs = masks.reduce<Map<string, number>>((acc, m) => {
      acc.set(m, value)
      return acc
    }, dataMap)
    // t0 = performance.now()
    dataMap = new Map([...dataMap, ...addrs])
    // t1 = performance.now()
    // console.log("Merging mask sets took " + (t1 - t0) + " milliseconds.")
    // console.log(dataMap.size)
  }
})

const iterator = dataMap.values()
let sum = 0
while (true) {
  let value = iterator.next().value
  if (!value) {
      break
  }
  sum += value
}

console.log(`Part 2: ${sum}`)
