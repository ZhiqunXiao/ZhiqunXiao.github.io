---
title: "Optimizing Contingent Plans with Parallel Relations and Leveled Plan Graphs"
collection: publications
permalink: /publication/2024-07-02-paper-title-number-2
excerpt: 'POCP: a parallel optimization approach that turns sequential contingent plan trees into leveled plan graphs, cutting robot task execution time by 12.5%-41% across three domains.'
date: 2024-07-02
type: manuscript
venue: 'National University of Defense Technology'
citation: 'Xiao, Z. (2024). &quot;Optimizing Contingent Plans with Parallel Relations and Leveled Plan Graphs.&quot; Manuscript, National University of Defense Technology.'
---

**Abstract.** In AI and robotics, contingent planning is one of the most promising planning algorithms for tackling uncertainty about the initial state with sensing capabilities. The contingent plan is essentially a tree-like structure that branches upon the observations received by each sensing action. However, the contingent plan only allows sequential action execution, not parallel execution, which results in low execution efficiency whenever actions are actually independent. To address this limitation, this work presents **POCP**, a parallel optimization approach for optimizing the execution of a contingent plan.

**Method.** POCP proceeds in three steps:

1. **Parallel relation identification** — a set of rules identifies the possible parallel relations that may exist within each branch among the actuating actions.
2. **Leveled plan graphs** — a planning graph model transforms each sequence of actions into a *leveled graph*, in which actions at the same level can be executed in parallel.
3. **POCP tree** — an algorithm combines the above graphs into a novel tree structure for the overall plan, with nodes connected by observation edges.

Executing a POCP plan means traversing the tree from the root to a leaf, then executing the actions of each graph node level by level.

**Experiments.** The approach is compared against the classical contingent planner CFF on three domains that cover the typical parallelizable robot scenarios, all carried out on the **TiaGo** mobile manipulation robot:

| Domain | Setting | Execution time reduction |
| :--- | :--- | :--- |
| CS-R1 | Single robot, number of customers increasing | ≈ 15% in all cases |
| CS-R2 | Two TiaGo robots, no collaboration | up to 41% on average |
| BP | Two TiaGo robots collaborating on heavy boxes | 12.5% – 28% |

The results demonstrate that POCP effectively improves the execution efficiency of robot tasks in unknown environments. A ROS/Gazebo demonstration of the plans being executed on a **TiaGo** mobile manipulation robot is available on the [homepage](/#demonstration-videos).
