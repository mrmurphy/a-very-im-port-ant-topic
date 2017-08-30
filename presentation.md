autoscale: true
text: Lato Bold
header: Lato Black
code: Iosevka

# [fit] A Very Im-port-ant Topic 
or, how I learned to stop worrying and love ports
## Murphy Randle
- Work: [Day One](https://dayoneapp.com)
- Twitter: [@splodingsocks](https://twitter.com/splodingsocks)
- Github: [@splodingsocks](https://twitter.com/splodingsocks)

![](img/title.jpg)

---

# [fit] Story Time
## [fit] or, how this talk was born

![](img/story-time.jpg)

[.footer: Photo by Dariusz Sankowski on Unsplash]

---
[.build-lists: true]

## The Situation
- Client-side database
- Hand-written native code to wrap DB

## The Sadness
- Runtime errors 😭
- No compiler help

[.footer: Story time]
---

## The Conversation
- Mentioned in Slack bad experience with native code
- Mentioned that using ports would be even worse

## The Change of Perspective
- Evan replied
- I had been using an incorrect mental model of ports
- I revised my brain and re-architected

[.footer: Story time]
---

# The Result
- No more native code
- 💸💰🤑💸💰🤑💸💰🤑
- Elm & JS remain separate worlds with separate concerns
- Scaling JS-Elm interaction is simple (a simple pattern is simple to follow)

[.footer: Story time]

---

# Let's do it together

---

![fit](img/pocket-journal-video-small.mov)

---

Our data is stored in IndexedDB, and we need to create, modify, and delete records (for starters)

---
# [fit] Ports

> [They're] like JavaScript-as-a-Service
-- guide.elm-lang.org

---

# [fit] First Attempt

---

## Make a port for each request and its accompanying response
```elm

port updateEntryContents : Entry -> Cmd msg
port updatedEntryContents : (Entry -> msg) -> Sub msg

port createEntry : () -> Cmd msg
port entryCreated : (Entry -> msg) -> Sub msg

port deleteEntry : Int -> Cmd msg
port entryDeleted : (Int -> msg) -> Sub msg
```

---

# What makes this hard and unpleasant?

---

# JavaScript as a service

- Ports make JavaScript == Service
  - BUT
    - Service `/=` server
    - Ports `/=` HTTP + Promises

---

# The Actor Model

The interaction between Elm & JS is modeled on a mature design pattern called *The Actor Model*

TODO: Insert table of languages that use the actor model and their years of inception

TODO: Cite the Elm Town episode

---

# The Actor Model: Information In & Information Out

TODO: Make the example of text messages vs phone calls

---

# Second Attempt

Show meaningful snippets from `InfoForOutside` and `InfoForElm`

---

# [fit] Why the Actor Model? A Case Study

--- 
TODO: Diagram of Day One before Web Workers
---
TODO: Diagram of Day One after Web Workers

^ The API for Web Workers follows a pattern like the Actor Model. No re-architecting and almost zero work was required to connect the JS back up with Elm after moving all of the JS code into a Web worker. Instead of two actors passing messages, we now had three. That's all.
---

# [fit] DEMO TIME

^ Demo the Day One Web app in full glory syncing multiple journals with hundreds of entries while still seamlessly navigating around the UI. Show off the async image loading as well.

---

# That's It!

- Contact info
- Sample code
- Elm Town
