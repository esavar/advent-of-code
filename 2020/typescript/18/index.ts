import { readFileSync } from 'fs'

const data = readFileSync('input.txt','utf8').split('\n')

const calculate = (input: string, preferAddition: boolean) => {
  const ops = input.split(' ')
  if (ops.length === 1) {
    return parseInt(input)
  }
  let result = parseInt(ops[0])
  let holdspace: number[] = []
  let c = 0
  while (c < ops.length - 1) {
    let x = parseInt(ops[c+2])
    switch (ops[c+1]) {
      case '+':
        result += x
        break
      case '*':
          if (preferAddition) {
            holdspace.push(result)
            result = x
          } else {
            result *= x
          }
        break
      default:
        console.log(`Unknown operator ${ops[c+1]}`)
        break
    }
    c += 2
  }
  if (preferAddition) return holdspace.reduce((acc, n) => acc *= n, result)
  return result
}

interface Parentheses {
  start: number
  end?: number
  result?: number
}

const resolveParenthesis = (input: string) => {
  let parenthesisQueue: Parentheses[] = []
  let parenthesisStack: Parentheses[] = []
  for (let i = 0; i < input.length; i++) {
    switch (input[i]) {
      case '(':
        parenthesisStack.push({start: i})
        break
      case ')':
        let pr = parenthesisStack.pop()
        if (!pr) {
          console.log('Invalid parenthesis')
          break
        }
        parenthesisQueue.push({...pr, end: i})
        break
      default:
        break
    }
  }
  return parenthesisQueue
}

const sumResults = (preferAddition: boolean) => {
  let sum = 0
  data.forEach((lolbal: string) => {
    const parenthesis = resolveParenthesis(lolbal)
    let calculation = ''
    let calculationQueue: Parentheses[] = []
    parenthesis.forEach((parentheses) => {
      calculation = ''
      let innerResults = calculationQueue.filter((c) => c.start > parentheses.start)
      if (innerResults.length) {
        let start = parentheses.start + 1
        innerResults.forEach((r) => {
          calculation += lolbal.substring(start, r.start) + r.result?.toString()
          // console.log(`calculation now ${calculation}`)
          start = r.end! + 1
        })
        calculation += lolbal.substring(start, parentheses.end!)
        // console.log(`calculation with inner ${calculation}`)
      } else {
        calculation = lolbal.substring(parentheses.start + 1, parentheses.end!)
        // console.log(`calculation other ${calculation}`)
      }
      let result = calculate(calculation, preferAddition)
      calculationQueue = calculationQueue.filter((c) => c.start < parentheses.start)
      calculationQueue.push({...parentheses, result})
    })

    calculation = ''
    if (calculationQueue.length === 0) {
      sum += calculate(lolbal, preferAddition)
    } else {
      let start = 0
      calculationQueue.forEach((c) => {
        calculation += lolbal.substring(start, c.start) + c.result?.toString()
        start = c.end! + 1
      })
      if (start < lolbal.length) calculation += lolbal.substring(start, lolbal.length)
      sum += calculate(calculation, preferAddition)
    }
  })

  return sum
}

console.log(`Part 1: ${sumResults(false)}`)
console.log(`Part 2: ${sumResults(true)}`)
