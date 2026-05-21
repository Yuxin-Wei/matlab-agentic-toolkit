# MATLAB Agentic Toolkit
The MATLAB&reg; Agentic Toolkit allows you to use AI agents with MATLAB by giving your AI agent the knowledge and context to work efficiently with MATLAB and its toolboxes. Use this toolkit to provide trusted MATLAB capabilities to your agent. This toolkit can prevent your AI coding agent from hallucinating toolbox functions, missing new features, and wasting time with extra steps that experienced MATLAB users would skip. 

Use this toolkit to: 

- Connect your AI agent to MATLAB. This toolkit does this by automatically installing the [MATLAB MCP Core Server](https://github.com/matlab/matlab-mcp-core-server). You can then use your agent to write idiomatic code, generate and run tests, diagnose errors, build apps, and more.

- Provide curated expertise, called skills, to your agent. These skills equip your agent with knowledge of MATLAB workflows, conventions, and best practices while minimizing token burn. 

> [!Note]
> To use AI agents with Simulink&reg;, install the [Simulink Agentic Toolkit](https://github.com/matlab/simulink-agentic-toolkit). To install both the toolkits in one step, see the [alternative installer](#alternative-installer).


## Requirements

* MATLAB R2020b or later
* Git&trade;
* AI coding agent. Supported agents include:
    - Claude Code
    - GitHub&reg; Copilot
    - OpenAI&reg; Codex
    - Gemini&trade; CLI
    - Sourcegraph Amp

## Get Started with the MATLAB Agentic Toolkit

These steps show you how to use the MATLAB Agentic Toolkit to install and configure the MATLAB MCP Core Server.

> Note: For detailed instructions on configuration options for this toolkit, platform-specific notes, verification steps, and troubleshooting, see [Configuration and Troubleshooting](Configuration_and_Troubleshooting.md). 

Clone the repository using this command.

```bash
git clone https://github.com/matlab/matlab-agentic-toolkit.git
cd matlab-agentic-toolkit
```

Deploy your agent (`claude`, `codex`, `gemini`, etc.) and ask the agent to set up the MATLAB Agentic Toolkit.

```
Set up the MATLAB Agentic Toolkit
```

The setup looks for your MATLAB installation(s), downloads the MCP server, writes your agent's global configuration, and registers skills. After your setup is complete, start a new session in any project directory to use the MATLAB tools and skills.


### Already Have the MCP Server?

If you installed the [MATLAB MCP Core Server](https://github.com/matlab/matlab-mcp-core-server) yourself, you just need skills. 

<a id="claude-code-marketplace-install"></a>
> **Claude Code**: If you have Claude Code, you can add skills directly using these commands.
> ```bash
> claude plugin marketplace add "https://github.com/matlab/matlab-agentic-toolkit"
> claude plugin install matlab-core@matlab-agentic-toolkit
> ```
> These commands install skills only. Your existing MCP configuration is not modified. 

For other AI coding agents, see [Adding Skills Only](Configuration_and_Troubleshooting.md#adding-skills-only).


<a id="alternative-installer"></a>
### Alternative Installer (experimental)

The Simulink Agentic Toolkit provides a MATLAB-based installer that can install and configure both toolkits. This installer offers several benefits over the current `matlab-agentic-toolkit-setup` skill:
* It can install both the MATLAB and Simulink Agentic Toolkits. It is recommended for users who would like to use both
* It supports the MATLAB MCP Core Server option to connect to an existing MATLAB session (`--matlab-session-mode=existing`)
* It provides the option to configure your agent to use the toolkits for individual projects, not just globally
* This installer does not consume agent tokens

The tradeoff is that it is newer and less thoroughly tested than the agent-driven setup above.

1. Download `agenticToolkitInstaller.mltbx` from the [Simulink Agentic Toolkit releases page](https://github.com/matlab/simulink-agentic-toolkit/releases).
2. Open the downloaded file to install the installer add-on.
3. In MATLAB, run: `setupAgenticToolkit`

### Verify
Ask your agent:

```
What version of MATLAB is running? List the installed toolboxes.
```

### Run and Test MATLAB Code Using MCP Tools 
After you install the MATLAB Agentic Toolkit, your agent can use these tools provided by the MATLAB MCP Core Server. 

| Tasks you can ask your agent to do | Tool used by agent |
|------|------------------------|
| Run MATLAB code and return command window output | `evaluate_matlab_code` |
| Run a MATLAB program | `run_matlab_file` | 
| Run tests via `runtests` with structured results | `run_matlab_test_file`| 
| Static analysis with the Code Analyzer | `check_matlab_code` |
| List installed MATLAB version and toolboxes | `detect_matlab_toolboxes` |

The server also provides two MCP resources: `matlab_coding_guidelines` (coding standards) and `plain_text_live_code_guidelines` (Live Script format rules).

### Run MATLAB Workflows Using Agent Skills 
After you install the MATLAB Agentic Toolkit, your agent can use these skills. To read details about all the skills, see the [skills catalog](skills-catalog/). Skills include:

<!-- BEGIN SKILLS -->
**Automotive** — automotive skills for AI coding agents.

**Computational Biology** — computational biology skills for AI coding agents.

**Image Processing and Computer Vision** — image processing and computer vision skills for AI coding agents.

**MATLAB App Building** — MATLAB app building skills for AI coding agents.

**MATLAB Core** — foundational MATLAB skills for AI coding agents.

**MATLAB Data Import and Analysis** — core MATLAB data import and analysis skills for AI coding agents.

**MATLAB Software Development** — MATLAB software development skills for AI coding agents.

**Reporting and Database Access** — reporting and database access skills for AI coding agents.

**RF and Mixed Signal** — RF and mixed-signal skills for AI coding agents.

**Robotics and Autonomous Systems** — robotics and autonomous systems skills for AI coding agents.

**Signal Processing** — signal processing skills for AI coding agents.

**Test and Measurement** — test and measurement skills for AI coding agents.

**Toolkit** — setup and management for the MATLAB Agentic Toolkit.

**Wireless Communications** — wireless communications skills for AI coding agents.

<!-- END SKILLS -->

## Security Considerations
When using the MATLAB Agentic Toolkit and MATLAB MCP Core Server, you should thoroughly review and validate all tool calls before you run them. Always keep a human in the loop for important actions and only proceed once you are confident the call will do exactly what you expect. For more information, see [User Interaction Model (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#user-interaction-model) and [Security Considerations (MCP)](https://modelcontextprotocol.io/specification/2025-06-18/server/tools#security-considerations).

## Licensing and Usage
The license is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository.

MCP servers are only permitted to be used with MATLAB in accordance with the MathWorks Software License Agreement, and must not be shared by multiple users. Contact MathWorks if you need to support shared or centralized server use.

## Support and Contributions
MathWorks encourages you to use this repository and provide feedback. To request technical support or submit an enhancement request, [create a GitHub issue](https://github.com/matlab/matlab-agentic-toolkit/issues) or [contact technical support](https://www.mathworks.com/support/contact_us.html). 

Pull requests are not enabled on this repository. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

----

Copyright 2026 The MathWorks, Inc.

----

