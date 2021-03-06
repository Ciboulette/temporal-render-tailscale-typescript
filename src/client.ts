import { Connection, WorkflowClient } from "@temporalio/client";
import { nanoid } from "nanoid";
import { example } from "./workflows";

async function run() {
  const connection = new Connection({
    // // Connect to localhost with default ConnectionOptions.
    // // In production, pass options to the Connection constructor to configure TLS and other settings:
    address: "TEMPORAL_FRONTEND_IP_ADDRESS", // as provisioned
    // tls: {} // as provisioned
  });

  const client = new WorkflowClient(connection.service, {
    // namespace: 'default', // change if you have a different namespace
  });

  const handle = await client.start(example, {
    args: ["Temporal"], // type inference works! args: [name: string]
    taskQueue: "hello-world",
    // in practice, use a meaningful business id, eg customerId or transactionId
    workflowId: "workflow-" + nanoid(),
  });
  console.log(`Started workflow ${handle.workflowId}`);

  // optional: wait for client result
  console.log(await handle.result()); // Hello, Temporal!
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
