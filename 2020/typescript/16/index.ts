import { readFileSync } from "fs";

const data = readFileSync('input.txt','utf8').split('\n')

interface Instruction {
  instruction: string
  ranges: number [][]
  possibleIndices?: number[] 
}

let readNearby = false
let myTicket: number[] = []
let nearbyTickets: number[][] = []
let instructions: Instruction[] = []
data.forEach((row, i) => {
  if (readNearby && row !== '') {
    nearbyTickets = nearbyTickets.concat([row.split(',').map((t) => parseInt(t, 10))])
  } else if (row.startsWith('your ticket')) {
    myTicket = data[i+1].split(',').map((t) => parseInt(t, 10))
  } else if (row.startsWith('nearby tickets')) {
    readNearby = true
  } else if (row.split(':').length > 1) {
    let instr = row.split(':')
    let ranges = instr[1].split('or')
    instructions.push({instruction: instr[0], ranges: ranges.map((ra) => ra.split('-').map((r) => parseInt(r.trim(), 10)))})
  }
})

// console.log(JSON.stringify(instructions))
// console.log(myTicket)
// console.log(nearbyTickets)

let sum = 0
let valid = true
let validTickets: number[][] = []
nearbyTickets.forEach((ticket, index) => {
  ticket.forEach((t) => {
    if (!instructions.find((instruction) => instruction.ranges.find((r) => t >= r[0] && t <= r[1]))) {
      sum += t
      valid = false
    }
  })
  if (valid) validTickets = validTickets.concat([nearbyTickets[index]])
  valid = true
})

console.log(`Part 1: ${sum}`)

let possibleOptions: Instruction[] = instructions.map((i) => ({...i, possibleIndices: []}))

instructions.forEach((instruction, index) => {
  let possibleIndices = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19] // [0,1,2]
  myTicket.forEach((t, i) => {
    if (!instruction.ranges.find((r) => t >= r[0] && t <= r[1])) {
      let rmIndex = possibleIndices.indexOf(i)
      possibleIndices.splice(rmIndex, 1)
      // console.log(`${instruction.instruction} cannot be ${i} based on my ticket`)
    }
  })
  validTickets.forEach((ticket) => {
    ticket.forEach((t, i) => {
      // console.log(`${t} ${i} ${instruction.ranges} ${instruction.ranges.find((r) => t >= r[0] && t <= r[1])}`)
      if (!instruction.ranges.find((r) => t >= r[0] && t <= r[1])) {
        let rmIndex = possibleIndices.indexOf(i)
        possibleIndices.splice(rmIndex, 1)
        // console.log(`${instruction.instruction} cannot be ${i} based on near by ticket at index ${nbIndex}`)
      }
    })
  })
  possibleOptions = possibleOptions.map((p, i) => {
    if (i === index) {
      // console.log(`setting possible indices ${possibleIndices} in instruction ${instruction.instruction}`)
      return {...p, possibleIndices}
    } else {
      return p
    }
  })
})

let counter = 20
let prevcounter = 20
let departureIndices: number[] = []
while (true) {
  let knownOptions = possibleOptions.filter((o) => o.possibleIndices?.length === 1)
  knownOptions.forEach((o) => {
    console.log(`Instruction ${o.instruction} is at index ${o.possibleIndices && o.possibleIndices[0]}`)
    if (o.instruction.startsWith('departure')) departureIndices.push(o.possibleIndices![0])
    possibleOptions = possibleOptions.reduce<Instruction[]>((acc, opt) => {
      if (o.instruction !== opt.instruction && opt.possibleIndices && o.possibleIndices && opt.possibleIndices.find((val) => val === o.possibleIndices![0]) !== undefined) {
        let rmIndex = opt.possibleIndices.indexOf(o.possibleIndices[0])
        let indices = opt.possibleIndices
        indices.splice(rmIndex, 1)
        acc.push({...opt, possibleIndices: indices })
        // console.log(`Possible indices now ${indices}`)
      } 
      return acc
    }, [])
  })
  counter -= knownOptions.length
  if (counter <= 0 || counter === prevcounter) {
    break
  }
  prevcounter = counter
}

if (possibleOptions.length > 0) {
  console.log(`Unresolved instructions ${JSON.stringify(possibleOptions)}`)
} else {
  console.log(`Part 2: ${departureIndices.reduce((acc, instrIdx) => acc * myTicket[instrIdx], 1)}`)
}
