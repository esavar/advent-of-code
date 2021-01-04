import { readFileSync } from 'fs'

const data = readFileSync('input.txt','utf8').split('\n')

interface Coordinates {
  x: number
  y: number
  z: number
  w?: number
}

interface ActiveCube {
  coords: Coordinates
  neighbors: Coordinates[]
}

interface Neighbor {
  coords: Coordinates
  count: number
}

const isEqual = (coords: Coordinates, otherCoords: Coordinates) => {
  return coords.x === otherCoords.x && coords.y === otherCoords.y && coords.z === otherCoords.z && coords.w === otherCoords.w
}

const getNeighbors = ({x, y, z, w}: Coordinates): Coordinates[] => {
  let neighbros = []
  for (let xi = -1; xi <= 1; xi++) {
    for (let yi = -1; yi <= 1; yi++) {
      for (let zi = -1; zi <= 1; zi++) {
        let xn = x + xi
        let yn = y + yi
        let zn = z + zi
        if (w !== undefined) {
          for (let wi = -1; wi <= 1; wi++) {
            let wn = w + wi
            if (!isEqual({x, y, z, w}, {x: xn, y: yn, z: zn, w: wn})) {
              neighbros.push({x: xn, y: yn, z: zn, w: wn})
            }
          }
        } else {
          if (!isEqual({x, y, z}, {x: xn, y: yn, z: zn})) {
            neighbros.push({x: xn, y: yn, z: zn})
          }
        }
      }
    }
  }
  return neighbros
}

const countActives = (fourthDimension: boolean) => {
  let activeCubes: ActiveCube[] = [] 
  let neighborCount: Map<string, Neighbor> = new Map()

  let y = 0
  for (let index=0; index<data.length; index++) {
    let row = data[index]
    let x = row.indexOf('#')
    let indexOf = x
    while (indexOf !== -1) {
      let neighbors = getNeighbors({x, y, z: 0, w: fourthDimension ? 0 : undefined})
      neighbors.forEach((n) => {
        let nKey = JSON.stringify(n)
        let nc = neighborCount.get(nKey)
        let count = nc ? nc.count + 1 : 1
        neighborCount.set(nKey, {coords: n, count})
      })
      activeCubes.push({coords: {x, y, z: 0, w: fourthDimension ? 0 : undefined}, neighbors})
      row = row.substring(indexOf+1)
      indexOf = row.indexOf('#')
      x = indexOf !== -1 ? x + 1 + indexOf : -1
    }
    y++
  }
  
  let nextIterActiveCubes: ActiveCube[] = []
  let nextIterNeighborCount: Map<string, Neighbor> = new Map()
  let iteration = 1
  for (let j=iteration; j<7; j++) {
    for (let i=0; i<activeCubes.length; i++) {
      let cube = activeCubes[i]
      let activeNeighbors = cube.neighbors.filter((cn) => activeCubes.find((ac) => isEqual(ac.coords, cn)))
      if (activeNeighbors.length === 2 || activeNeighbors.length === 3) {
        nextIterActiveCubes.push(cube)
        cube.neighbors.forEach((n) => {
          let nKey = JSON.stringify(n)
          let nc = nextIterNeighborCount.get(nKey)
          let count = nc ? nc.count + 1 : 1
          nextIterNeighborCount.set(nKey, {coords: n, count})
        })
      }
    }
    
    const iterator = neighborCount.values()
    let value: Neighbor | undefined = iterator.next().value
    while (value) {
      if (value.count === 3) {
        if (!nextIterActiveCubes.find((ni) => isEqual(ni.coords, value!.coords))) {
          let neighbors = getNeighbors(value.coords)
          neighbors.forEach((n) => {
            let nKey = JSON.stringify(n)
            let nc = nextIterNeighborCount.get(nKey)
            let count = nc ? nc.count + 1 : 1
            nextIterNeighborCount.set(nKey, {coords: n, count})
          })
          nextIterActiveCubes.push({coords: value.coords, neighbors})
        }
      }
      value = iterator.next().value
    }
    
    activeCubes = nextIterActiveCubes
    neighborCount = nextIterNeighborCount
    nextIterNeighborCount = new Map
    nextIterActiveCubes = []
    // console.log(neighborCount.size)
  }

  return activeCubes.length
}

console.log(`Part 1: ${countActives(false)}`)
console.log(`Part 2: ${countActives(true)}`)
