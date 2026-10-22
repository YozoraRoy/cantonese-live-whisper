# Cantonese Live Whisper

A personal fork of [jt-live-whisper](https://github.com/jasoncheng7115/jt-live-whisper) focused on Cantonese speech recognition and Traditional Chinese output.

## What is this repo?

This is a personal fork of [jasoncheng7115/jt-live-whisper](https://github.com/jasoncheng7115/jt-live-whisper). It is **not** an official release and is not endorsed by the original author.

I recently joined online work meetings conducted in Cantonese and could not follow the discussion. The original project already provides real-time speech recognition, translation, a WebUI, system-audio capture, and an on-device AI pipeline, so I did not rewrite it from scratch. Instead, I added Cantonese-to-Traditional-Chinese modes, model integration, and usage documentation.

The original project is developed by **Jason Cheng (Jason Tools)**. He originally built it to help with English-language technical courses; the project has grown considerably since then. For the complete feature set, installation instructions, screenshots, and latest updates, please refer to the original project:

- **Project website:** <https://jasoncheng7115.github.io/jt-live-whisper/>
- **Original repository:** <https://github.com/jasoncheng7115/jt-live-whisper>

## Cantonese support in this fork

- `yue` — Cantonese speech to a Traditional Chinese colloquial transcript (preserves 冇, 嘅, 咗).
- `yue2zh` — Cantonese speech to Traditional Chinese written Chinese, using a local LLM.
- Uses `yue-whisper-turbo` locally through faster-whisper.
- Selectable from both the WebUI and the command line.
- Includes guidance for capturing Microsoft Teams / Zoom system audio with WASAPI Loopback.

See [README_YUE.md](README_YUE.md) for the detailed Cantonese setup and usage guide (Traditional Chinese).

## Project website

The original project's website contains the full feature overview, screenshots, installation guide, and usage documentation:

<https://jasoncheng7115.github.io/jt-live-whisper/>

## Disclaimer

This repository is an unofficial personal fork. It is not affiliated with, sponsored by, or endorsed by Jason Cheng / Jason Tools. The original project is the authoritative source for its features, documentation, and support.

This fork is provided **"as is"**, without warranty of any kind, express or implied. Use it at your own risk. You are responsible for ensuring that your use of meeting audio, transcripts, and personal data complies with applicable laws and your organization's policies.

## License

This fork is distributed under the **Apache License 2.0**, inherited from the original project. See [LICENSE](LICENSE) and [NOTICE](NOTICE) for the full license text and attribution.

Third-party components and models retain their own licenses, including:

- Cantonese Whisper model `JackyHoCL/whisper-large-v3-turbo-cantonese-yue-english-ct2` — MIT
- Qwen2.5-7B-Instruct — Apache-2.0
- OpenAI Whisper — MIT

Please review the upstream project's [COMPLIANCE.md](COMPLIANCE.md) for additional component and model licensing information.
