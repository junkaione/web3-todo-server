import { expect } from "chai";
import { ethers } from "hardhat";

describe("Lock", function () {
  let todolist: any;
  let owner: any;

  before(async function () {
    [owner] = await ethers.getSigners();
    todolist = await ethers.deployContract("TodoList");
  });

  it("should create a new task", async function () {
    const taskName = "Sample Task";
    const taskDescription = "This is a sample task description";
    await todolist.createTask(taskName, taskDescription);

    const tasks = await todolist.getTask();
    expect(tasks.length).to.equal(1);
  });

  it("should mark a task as completed", async function () {
    await todolist.markTaskCompleted(0);
    const tasks = await todolist.getTask();
    const isCompleted = tasks[0][4];
    expect(isCompleted).to.equal(true);
  });

  it("should delete a task", async function () {
    await todolist.createTask(
      "Task to be deleted",
      "This task will be deleted"
    );

    const tasks = await todolist.getTask();
    expect(tasks.length).to.equal(2);

    await todolist.deleteTask(1);
    const newTasks = await todolist.getTask();
    expect(newTasks.length).to.equal(1);
  });
});
