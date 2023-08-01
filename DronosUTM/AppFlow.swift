//
//  AppFlow.swift
//  DronosUTM
//
//  Created by zvhir on 27/07/2023.
//  Copyright © 2023 DJI. All rights reserved.
//

/* DRONOS UTM Mobile App Flow
*
* ┌─────────────┐               ┌─────────┐                   ┌──────────────┐
* │ Mobile Apps │               │   API   │                   │ Local SQLite │
* └──────┬──────┘               └────┬────┘                   └───────┬──────┘
*        │                           │                                │
*        │                           │           Save TOKEN           │
*        │─────────loginAuth────────▶│────────{"token": "XXXx"}──────▶│
*        │                           │                                │
*        │                           │                                │
*        │                           │                                │
*        │                           ├─parse style─┐                  │
*        │                           │             │                  │
*        │      StyleDataLoaded      ◀─────────────┘                  │
*        │◀────{"type": "style"}─────┤                                │
*        │                           ├─────────get sprite────────────▶│
*        │                           │                                │
*        │                           │◀────────sprite data────────────┤
*        │                           │                                │
*        │                           ├──────parse sprite───────┐      │
*        │                           │                         │      │
*        │      StyleDataLoaded      ◀─────────────────────────┘      │
*        │◀───{"type": "sprite"}─────┤                                │
*        │                           ├─────get source TileJSON(s)────▶│
*        │                           │                                │
*        │     SourceDataLoaded      │◀─────parse TileJSON data───────┤
*        │◀──{"type": "metadata"}────┤                                │
*        │                           │                                │
*        │                           │                                │
*        │      StyleDataLoaded      │                                │
*        │◀───{"type": "sources"}────┤                                │
*        │                           ├──────────get tiles────────────▶│
*        │                           │                                │
*        │◀───────StyleLoaded────────┤                                │
*        │                           │                                │
*        │     SourceDataLoaded      │◀─────────tile data─────────────┤
*        │◀────{"type": "tile"}──────┤                                │
*        │                           │                                │
*        │                           │                                │
*        │◀────RenderFrameStarted────┤                                │
*        │                           ├─────render─────┐               │
*        │                           │                │               │
*        │                           ◀────────────────┘               │
*        │◀───RenderFrameFinished────┤                                │
*        │                           ├──render, all tiles loaded──┐   │
*        │                           │                            │   │
*        │                           ◀────────────────────────────┘   │
*        │◀────────MapLoaded─────────┤                                │
*        │                           │                                │
*        │                           │                                │
*        │◀─────────MapIdle──────────┤                                │
*        │                    ┌ ─── ─┴─ ─── ┐                         │
*        │                    │   offline   │                         │
*        │                    └ ─── ─┬─ ─── ┘                         │
*        │                           │                                │
*        ├─────────setCamera────────▶│                                │
*        │                           ├───────────get tiles───────────▶│
*        │                           │                                │
*        │                           │┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │
*        │◀─────────MapIdle──────────┤   waiting for connectivity  │  │
*        │                           ││  Map renders cached data      │
*        │                           │ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
*        │                           │                                │
*
*/

