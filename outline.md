# RPI with Coding Agents


## Intro

### Research, Plan, Implement

Today we'll cover Research->Plan->Implement (RPI) methodology for writing software with Agentic Coding Tools.
 
1. During research phase we create with AI's help, we'll create what equates to the ultimate ticket:
    1. The request
    1. Documention for the related parts of the code.
    2. Decisions we need to make

2. During plan phase we'll document the code changes required.
3. Lastly, we'll have the ai coding agent implement the plan.

### Background: Avoding rework 
Prompting to implement has been equated to a slot machine. You keep pulling hoping to get lucky. When it doesn't give you the results you want, you start pulling again with prompts like "No not that, this", and the agent responds, "Of course!". 

What is happening during this spiral:
0. The models are trained to do what you request, and their praise of the request is sycophantic.
1. complexity of the code base is increasing on each pull (spaghettification)
2. context window of the agent is filling up so its getting dumber
3. some speculate that it is in context learning to give you bad results

The goal of some up front planning is to minimize rework to prevent spirals.

### What is our role?
LLMs seem impressive and all-knowing, but they are not replacing us for two reasons. We must be the decision makers for two reasons.

1. they lack the context of your organization, we provide it
    - They are a new person on the job — they don't know what they don't know
    - Every decision in software development requires organizational context: team conventions, business constraints, historical decisions, dependencies, user needs
    - LLMs cannot hold that context in their heads — it's not in the training data, and it won't fit in a single prompt
2. Humans provide the engineering — LLMs provide pattern matching on what they've been trained on
    - If the solution you need is outside the distribution of what the LLM has seen, its ability to engineer is quite limited
    - Anything truly novel — something that has never been created before — requires human engineering judgment
    - The LLM can help with the parts that look like things it's seen, but the creative leaps and novel architecture are yours


## Let's research!

Let's start with a simple example. This will be a bit contrived since we want to focus on the prompting required to keep us in the loop and not get too in the weeds on the architecture of a system you're unfamiliar with. The goal is that you'll then be able to take these prompts and then dig in on a task related to your domain.

We'll start by generating a simple todo app and then apply our research prompts in service of adding a dark mode/light mode switcher for the application.