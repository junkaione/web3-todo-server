// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TodoList {
    // 任务
    struct Task {
        uint id;
        uint date;
        string name;
        string description;
        bool isCompleted;
        address owner;
    }

    // 所有任务列表
    Task[] public tasks;

    // 用户任务列表
    mapping(address => uint[]) private userTasks;

    // 任务创建事件
    event TaskCreated(
        uint id,
        uint date,
        string name,
        string description,
        bool isCompleted,
        address owner
    );

    // 任务完成事件
    event TaskCompleted(uint id, address owner);

    // 任务删除事件
    event TaskDeleted(uint id, address owner);

    // 创建任务
    function createTask(string memory name, string memory description) public {
        // 生成任务ID
        uint taskId = tasks.length;
        // 创建新任务并加到任务列表
        tasks.push(
            Task(taskId, block.timestamp, name, description, false, msg.sender)
        );
        // 把任务ID添加到用户任务列表
        userTasks[msg.sender].push(taskId);
        // 执行任务创建事件
        emit TaskCreated(
            taskId,
            block.timestamp,
            name,
            description,
            false,
            msg.sender
        );
    }

    // 获取任务
    function getTask(
        uint id
    )
        public
        view
        returns (uint, uint, string memory, string memory, bool, address)
    {
        require(id < tasks.length, "Task ID does not exist");
        Task storage task = tasks[id];
        return (
            task.id,
            task.date,
            task.name,
            task.description,
            task.isCompleted,
            task.owner
        );
    }

    // 标注任务已完成
    function markTaskCompleted(uint id) public {
        require(id < tasks.length, "Task ID does not exist");
        Task storage task = tasks[id];
        require(task.owner == msg.sender, "Only Owner can complete this task");
        require(!task.isCompleted, "Task is already completed");
        task.isCompleted = true;
        emit TaskCompleted(id, msg.sender);
    }

    // 删除任务
    function deleteTask(uint id) public {
        require(id < tasks.length, "Task ID does not exist");
        Task storage task = tasks[id];
        require(task.owner == msg.sender, "Only Owner can complete this task");
        uint lastIndex = tasks.length - 1;
        if (id != lastIndex) {
            Task storage lastTask = tasks[lastIndex];
            tasks[id] = lastTask;
            userTasks[msg.sender][id] = lastIndex;
        }
        tasks.pop();
        userTasks[msg.sender].pop();
        emit TaskDeleted(id, msg.sender);
    }

    function getUserTasks() public view returns (uint[] memory) {
        return userTasks[msg.sender];
    }
}
