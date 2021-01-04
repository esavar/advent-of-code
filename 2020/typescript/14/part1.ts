import { readFileSync } from 'fs'

const data = readFileSync('input.txt','utf8').split('\n')

const dataObj: Record<string, string> = {}
let currentMask: string = ''
data.forEach((elem: string) => {
  if (elem.startsWith('mask')) {
    currentMask = elem.split('=')[1].trim()
  } else if (elem.startsWith('mem')) {
    let value = parseInt(elem.split('=')[1].trim()).toString(2).padStart(36, '0')
    let i = value.length
    while (i--) {
      if (currentMask[i] !== 'X') {
        value = value.substring(0, i) + currentMask[i] + value.substring(i + 1)
      }
    }
    const addr = elem.substring(elem.lastIndexOf('[') + 1, elem.lastIndexOf("]"))
    dataObj[addr] = value
  }
})

const result = Object.keys(dataObj).reduce((sum, key) => sum += parseInt(dataObj[key], 2), 0)
console.log(`Part 1: ${result}`)
