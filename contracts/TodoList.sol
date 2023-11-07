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
        bool isDeleted;
        address owner;
    }

    // 所有任务列表
    Task[] private tasks;

    // 任务创建事件
    event TaskCreated(uint id, address owner);

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
            Task(
                taskId,
                block.timestamp,
                name,
                description,
                false,
                false,
                msg.sender
            )
        );
        // 执行任务创建事件
        emit TaskCreated(taskId, msg.sender);
    }

    // 获取用户所有任务
    function getTask() public view returns (Task[] memory) {
        Task[] memory temporary = new Task[](tasks.length);
        uint counter = 0;
        for (uint i = 0; i < tasks.length; i++) {
            if (tasks[i].owner == msg.sender && tasks[i].isDeleted == false) {
                temporary[counter] = tasks[i];
                counter++;
            }
        }
        Task[] memory result = new Task[](counter);
        for (uint i = 0; i < counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }

    // 标注任务已完成
    function markTaskCompleted(uint id) public {
        require(
            id < tasks.length || tasks[id].isDeleted == true,
            "Task ID does not exist"
        );
        Task storage task = tasks[id];
        require(task.owner == msg.sender, "Only Owner can complete this task");
        require(!task.isCompleted, "Task is already completed");
        task.isCompleted = true;
        emit TaskCompleted(id, msg.sender);
    }

    // 删除任务
    function deleteTask(uint id) public {
        require(
            id < tasks.length || tasks[id].isDeleted == true,
            "Task ID does not exist"
        );
        Task storage task = tasks[id];
        require(task.owner == msg.sender, "Only Owner can complete this task");
        tasks[id].isDeleted = true;
        emit TaskDeleted(id, msg.sender);
    }
}
