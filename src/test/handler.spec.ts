import { hello } from '../functions/handler'
import { expect } from 'chai'
import 'mocha'

const context: any = {
  callbackWaitsForEmptyEventLoop: false
}
describe('Hello Handler Test', () => {
  it ('Hello test', () => {
    return hello({}, context , (error, response) => {
      console.log(response)
      expect(response).to.not.be.empty
    })
  })
})