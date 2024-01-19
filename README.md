# Thread and Process Scheduling

# Problem Statement

## Linux pthreads and Process Scheduling Benchmarking

### Problem Overview

This exercise aims to explore and benchmark the scheduling policies for both Linux pthreads and processes. The task involves creating and running three threads (Thr-A, Thr-B, and Thr-C) with different scheduling disciplines and priorities, along with three processes, each compiling a copy of the Linux kernel source.

### Task Description

#### 1. Thread Scheduling (Total points: 80)

1.1 **Thread Specification**

- **Thr-A**: Uses SCHED OTHER scheduling discipline with standard priority (nice:0).
- **Thr-B**: Uses SCHED RR scheduling discipline with default priority.
- **Thr-C**: Uses SCHED FIFO scheduling discipline with default priority.

Each thread must execute a function (countA(), countB(), and countC() respectively) that counts from 1 to 2^32. Use the `clock_gettime()` function to measure the time taken for each function.

**Benchmarking:**

- Change the scheduling classes of the three threads (keeping priorities the same) using `pthread_schedsetparam()` and related functions.
- Generate histograms showing task completion times for each scheduler. The histogram should use different colors for bars, with one axis representing the time taken to complete and the other showing thread priorities.

1.2 **Process Scheduling**

Create three processes using `fork()`, each involving the compilation of the Linux kernel source. The child processes should use `execl()` family system calls to run different bash scripts, each containing commands to compile the kernel.

**Benchmarking:**

- Measure the execution time using `clock_gettime()` before forking and after each process terminates (using `waitpid()` to identify termination).
  
### Submission/Rubric

1. **Successful Compilation** (10 points)
   - All three programs compile successfully.

2. **Thread Creation and Execution** (10 points)
   - Threads (Thr-A, Thr-B, and Thr-C) are created and invoke their respective count functions correctly.

3. **System Calls Usage** (20 points)
   - Appropriate use of system calls for creating processes and threads, setting scheduling discipline, and priorities.

4. **Runtime Benchmarking and Histograms** (30 points)
   - Fully reproducible behavior: 30 points.
   - Predictable and explainable runtimes controlled by the scheduler: 20 points.
   - Otherwise, no points.

5. **Makefile** (5 points)
   - A fully functioning Makefile is provided.

6. **README/Write-up** (5 points)
   - Describe the program logic in no more than one page.
   - Explain the outcomes of tests and measurements.

### Note

- Any program that does not compile or does not perform the specified tasks correctly will receive no points.
- The focus is on accuracy, adherence to specifications, and clarity in the submission.



# Program Logic and Test/Measurement Outcomes (Q1.1)

## Program Logic

1. **Function Creation:**
   - I created three functions, `countA()`, `countB()`, and `countC()`, to perform the counting task from 1 to 2^32.

2. **Thread Creation Functions:**
   - Developed three functions for creating threads, each corresponding to a specific scheduling policy.

3. **Thread Creation and Configuration:**
   - In the main function, I created three threads, each using one of the thread creation functions.
   - Set thread scheduling policies and priorities using `pthread_attr_setschedpolicy` and `pthread_attr_setschedparam`.
   - Repeated this process to create threads with different scheduling priorities.

4. **Thread Joining:**
   - Used `pthread_join` to wait for the completion of each triad of threads.

5. **Time Tracking:**
   - Utilized `clock_gettime` before and after calling the counting functions to track the start and end times.
   - Stored the differences between start and end times in arrays and text files, representing the processing time for each thread.

6. **Histogram Plotting:**
   - Created a separate Python script using `matplotlib` to plot the execution time of the three processes into a histogram.

## Outcomes of Tests/Measurements

- **SCHED_OTHER:**
  - Takes the maximum time in all three runs on average.
  
- **SCHED_FIFO:**
  - On average, takes less time than SCHED_RR.
  - Generally, lower processing time, consistent with the expected behavior.

- **SCHED_RR:**
  - Takes more time than SCHED_FIFO on average.
  - Observed some anomalies, possibly due to the code running on a virtual machine (VM) with shared system resources between Windows and the VM.

### Anomalies Explanation:

1. **VM Resource Sharing:**
   - The VM shares resources with Windows, impacting runtime.
   - Anomalies may arise due to resource contention.

2. **VM Running on 2 Cores:**
   - The VM runs on 2 cores, potentially causing differences in processing time.
   - Parallel execution of two threads may influence results.

3. **Overall Predictability:**
   - Despite anomalies, runtimes generally align with predictions.
   - Anomalies explained by the VM environment and shared resources.

**Note:** The code behavior is affected by the VM environment, and anomalies should be considered in the context of virtualization.



## Program Logic and Test/Measurement Outcomes (Q1.2)

### Program Logic

I initiated the program by creating three arrays to store the execution time of processes with different scheduling policies (SCHED_OTHER, SCHED_RR, SCHED_FIFO). The following steps outline the program logic:

1. **Child Process Creation:**
   - Used `fork()` twice to create three child processes with one parent.
   - Checked for child processes using if-else statements.
   - Utilized `setpriority()` function to set the scheduling policy and priority of the processes simultaneously.

2. **Execution of Bash Scripts:**
   - Employed if-else statements to check for the child processes.
   - Used `exec()` system call to run corresponding bash scripts.

3. **Parent Process Handling:**
   - In the parent process, used `waitpid()` to wait for all three child processes to finish execution.

4. **Kernel Compilation:**
   - After child processes completed execution, called `fork()` twice again from the parent to create three child processes (and one parent) for kernel compilation.
   - Repeated this step once more.

5. **Time Tracking:**
   - Used `clock_gettime` before using `fork()` for each process to track the starting time.
   - Used `clock_gettime` after child processes finished their execution to track the ending time.
   - Added the difference of start time and end time into three different arrays as the processing time for the three threads.

6. **Histogram Plotting:**
   - Created a separate Python script using `matplotlib` to plot the execution time of the three processes into a histogram.
   - Mentioned the need for GitHub to upload `.txt` files and downloading them on Windows for plotting, as `matplotlib` is GUI-based.

### Outcomes of Tests/Measurements

- **SCHED_OTHER:**
  - Takes the lowest time in all three runs on average.
  
- **SCHED_RR:**
  - On average, takes greater time than SCHED_FIFO. In the first three tests, it is slightly less than SCHED_FIFO.
  
- **SCHED_FIFO:**
  - Takes less time than SCHED_RR on average. In the first three tests, it is slightly more than SCHED_RR.

#### Reasons/Explanation:

1. **Scheduling Policies:**
   - Generally, SCHED_FIFO takes lower time than SCHED_RR, as expected from sources.
  
2. **Anomalies Explanation:**
   - Running on a VM with shared resources between Windows and the VM may result in anomalies in runtime.
   - Kernel compilation being a lengthy process, any Windows process during that period could impact the processing times.
   - The VM running on 2 cores may cause differences in processing time, allowing two processes to run in parallel.
  
3. **Child Process Handling:**
   - Creating only three processes as specified in the question required calling `fork()` twice, creating four processes (1 parent & 3 children).
   - Use of `waitpid()` is essential for proper program functioning, affecting benchmarking.

**Note:** Anomalies should be considered within the context of VM and shared resources. Despite anomalies, runtimes align with predictions.
