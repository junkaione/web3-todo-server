import { ethers } from "hardhat";

async function main() {
  const TodoList = await ethers.deployContract("TodoList");
  console.log("Deploying contract.....");
  await TodoList.waitForDeployment();
  console.log(`TodoList deployed to ${TodoList.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
