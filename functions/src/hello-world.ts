import wrapper from "./shared/wrapper";

export const execute = wrapper(async () => {
  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello, World!" }),
  };
});
