import { hello } from '../../functions/handler'
import { expect } from 'chai'
import 'mocha'
interface HelloResponseBody {
  message : number
}

const context: any = {
  callbackWaitsForEmptyEventLoop: false
}
describe('Hello Handler Test', () => {
  it ('Hello test', () => {
    return hello({}, context , (error, response: any ) => {
      console.log(response)
      expect(response).to.not.be.empty
      if (response &&
      response.body) {
      let responseBody : HelloResponseBody = JSON.parse(response.body)
      expect(responseBody.message).to.be.gte(1)
      expect(responseBody.message).to.be.lte(10)
      }
    })
  })
})