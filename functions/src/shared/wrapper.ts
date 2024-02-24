import type { LambdaFunctionURLCallback } from "aws-lambda";

const wrapper = (fn: LambdaFunctionURLCallback): LambdaFunctionURLCallback => {
  return async (event, context) => {
    try {
      return await fn(event, context);
    } catch (error: any) {
      return {
        statusCode: 500,
        body: JSON.stringify({ error: error.message }),
      };
    }
  };
};

export default wrapper;
