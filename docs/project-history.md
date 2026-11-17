# How the project evolved

## Three months of building and learning

I developed the initial project over three months. I began with Docker and Docker Compose. At that point, I did not know what Kubernetes was, and this project became my first experience using it.

The move to Kubernetes happened only in the **last month** of those three months. It was the result of learning during the project, rather than an architecture I had planned from the beginning. TechWorld with Nana's Kubernetes tutorial and the Kubernetes documentation helped me understand the concepts and apply them to my own services.

As I learned more, Docker Compose no longer fit the orchestration and deployment concepts I wanted to explore. I moved the project entirely to Kubernetes. Keeping Compose and Kubernetes configurations in sync would have meant too much maintenance, so I kept the older implementation as a Git tag instead of continuing to support both.

## Learning through documentation and source code

I spent substantial time studying documentation directly: Kubernetes resources and networking, Spring Boot and Spring AOP, authentication, messaging, certificates, and the monitoring and logging tools used here. Tutorials helped me get started, but applying the ideas meant reading configuration references and returning to the documentation while debugging.

Grafana Alloy was a particularly clear example. It was a new concept to me at the time, and relevant videos and tutorials were scarce. I could find only **one relevant YouTube video** then. Much of the work therefore involved reading Alloy's documentation, understanding its components, and tracing how discovery, labels, file collection, and forwarding fit together.

Reading other people's GitHub implementations also helped me learn. I looked at small libraries and focused examples as well as larger libraries and complete implementations to understand how other developers solved related problems. I compared those approaches with the documentation and worked through how they applied to this project.

## My work and use of AI

I developed the project with help from ChatGPT, working through the implementation file by file. I wrote code, worked to understand every part, used logs to diagnose and solve problems, and tested the implementation myself. ChatGPT helped me explore concepts and work through technical questions alongside tutorials, official documentation, and other people's source code.

I now use **Codex to help write and organize the project documentation**, including the migration to Zensical. This follows the earlier use of ChatGPT chat during development, alongside my own implementation work, investigation, debugging, and testing.

## Preserved versions

| Tag | Purpose |
| --- | --- |
| `Docker-Compsoe-Version` | Historical Docker Compose implementation; no longer maintained |
| `pre-codex` | Commit `b0e81f1e2e03e2289a4ba38446f3d3ae77bbbd09`, tagged before the Codex documentation migration |

The `pre-codex` tag marks the committed repository state at the start of this migration. Git tags do not include uncommitted files, and the name does not mean the earlier development was free of AI assistance. Tags created locally become available to other clones only after they are pushed.

## Learning references

These are starting points for the concepts used here, not a complete historical bibliography:

- [TechWorld with Nana](https://www.youtube.com/@TechWorldwithNana): the Kubernetes tutorial was part of my introduction.
- [Kubernetes documentation](https://kubernetes.io/docs/home/): workloads, Services, configuration, and networking.
- [Spring AOP documentation](https://docs.spring.io/spring-framework/reference/core/aop.html): aspects and proxy-based interception.
- [Grafana Alloy documentation](https://grafana.com/docs/alloy/latest/): component configuration and log collection.

See the [repository map](reference/repository.md) to connect these concepts with the implementation.
