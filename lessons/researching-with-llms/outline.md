# Researching with Coding Agents


## Intro

- Prompting to implement has been equated to a slot machine. You keep pulling hoping to get lucky.
- What is going on under the hood is
    1. complexity of the code base is increasing on each pull (spaghettification)
    2. context window of the agent is filling up so its getting dumber
    3. some speculate that it is in context learning to give you bad results
- LLMs seem impressive and all-knowing, but they lack the context of your organization
    - They are a new person on the job — they don't know what they don't know
    - Every decision in software development requires organizational context: team conventions, business constraints, historical decisions, dependencies, user needs
    - LLMs cannot hold that context in their heads — it's not in the training data, and it won't fit in a single prompt
- It is your job to translate organizational needs into the decisions being made while coding
    - If you do not insert yourself into the decision-making process, the LLM will make a bad call
    - Those bad calls compound — each wrong assumption becomes the foundation for the next decision, and the codebase drifts further from what your organization actually needs
- This is why we don't just hand the LLM a task and say "go build it"
    - Before coding or planning, we need to do the research ourselves and capture it in a way the LLM can use
    - That's the role of a research.md — a document that gives the LLM the organizational context it's missing, so its decisions are grounded in reality instead of guesswork
