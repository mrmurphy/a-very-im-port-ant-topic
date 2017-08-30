port module BadPortExample exposing (..)

-- Make a port for each request and its accompanying response
port updateEntryContents : Entry -> Cmd msg
port updatedEntryContents : (Entry -> msg) -> Sub msg

port createEntry : () -> Cmd msg
port entryCreated : (Entry -> msg) -> Sub msg

port deleteEntry : Int -> Cmd msg
port entryDeleted : (Int -> msg) -> Sub msg

-- Plus a new Msg for each one of the "responses" above:
type Msg = OtherMessages
    -- ...
    | EntryUpdated Entry
    | EntryCreated Entry
    | EntryDeleted Int

-- Plus a case for each of those new msgs in the update function
update msg model =
    case msg of 
        -- other messages ...
        EntryUpdated entry -> 
            -- Find this entry in memory and update it
        EntryCreated entry ->
            -- Add this entry to the front of the list
        EntryDeleted id_ ->
            -- Find the entry with this ID in memory and remove it from the list

-- Plus a new subscription for each of those messages:
subscriptions = \model -> Sub.batch 
    [ updatedEntryContents EntryUpdated
    , entryCreated EntryCreated
    , entryDeleted EntryDeleted
    ]

-- Plus code on the Javascript side to subscribe to and trigger each of the ports
app.ports.updateEntryContents.subscribe(entry => {
    // ... Interact with the database, get the updated entry, and then:
    app.ports.updatedEntryContents.send(updatedEntry)
})
app.ports.createEntry.subscribe(_ => {
    // ... Create a new entry, stick it in the DB, and then:
    app.ports.entryCreated.send(newEntry)
})
app.ports.deleteEntry.subscribe(id => {
    // ... Delete the entry with that ID from the database and then updated it:
    app.ports.entryDeleted.send(id)
})

