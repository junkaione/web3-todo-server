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

    const [id, date, name, description, isCompleted, taskOwner] =
      await todolist.getTask(0);
    expect(id).to.equal(0);
    expect(name).to.equal(taskName);
    expect(description).to.equal(taskDescription);
    expect(isCompleted).to.equal(false);
    expect(taskOwner).to.equal(owner.address);
  });

  it("should mark a task as completed", async function () {
    await todolist.markTaskCompleted(0);
    const [, , , , isCompleted] = await todolist.getTask(0);
    expect(isCompleted).to.equal(true);
  });

  it("should delete a task", async function () {
    await todolist.createTask(
      "Task to be deleted",
      "This task will be deleted"
    );

    await todolist.deleteTask(1);

    let isError = false;
    try {
      await todolist.getTask(1);
    } catch (error) {
      isError = true;
    }
    expect(isError).to.equal(true);
  });

  it("should retrieve the user's tasks", async function () {
    await todolist.createTask("User's Task", "This is the user's task");
    const userTasks = await todolist.getUserTasks();
    expect(userTasks.length).to.be.at.least(1);
  });
});
