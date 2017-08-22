import "./main.css";
import { Main } from "./Main.elm";

var app = Main.embed(document.getElementById("root"));

app.ports.infoForOutside.subscribe(msg => {
  if (msg.tag == "ErrorLogRequested") {
    console.error(msg.data);
  } else if (msg.tag == "EntryCreationRequested") {
    localforage
      .length()
      .then(length => {
        var newEntry = { id: length, date: Date.now(), content: "" };
        return localforage.setItem("entry:" + length, newEntry);
      })
      .then(sendEntries)
      .catch(console.error);
  } else if (msg.tag == "EntryModified") {
    localforage
      .setItem("entry:" + msg.data.id, msg.data)
      .then(sendEntries)
      .catch(console.error);
  } else if (msg.tag == "EntryDeleted") {
    localforage
      .removeItem("entry:" + msg.data)
      .then(sendEntries)
      .catch(console.error);
  }
});

function addEntry(entry) {
  return localforage.setItem("entry:" + entry.id, entry);
}

function sendEntries() {
  var entries = [];
  localforage
    .length()
    .then(length => {
      if (length == 0) {
        return Promise.all(defaultEntries.map(addEntry));
      }
    })
    .then(_ =>
      localforage.iterate(value => {
        entries.push(value);
      })
    )
    .then(() => {
      app.ports.infoForElm.send({ tag: "EntriesChanged", data: entries });
    })
    .catch(console.error);
}

sendEntries();

var defaultEntries = [
  {
    id: 0,
    date: -2542792568000,
    content:
      "Harris said he didn’t think George ought to do anything that would have a tendency to make him sleepier than he always was, as it might be dangerous.  He said he didn’t very well understand how George was going to sleep any more than he did now, seeing that there were only twenty-four hours in each day, summer and winter alike; but thought that if he did sleep any more, he might just as well be dead, and so save his board and lodging."
  },
  {
    id: 1,
    date: -2542691568000,
    content:
      "We arranged to start on the following Saturday from Kingston.  Harris and I would go down in the morning, and take the boat up to Chertsey, and George, who would not be able to get away from the City till the afternoon (George goes to sleep at a bank from ten to four each day, except Saturdays, when they wake him up and put him outside at two), would meet us there."
  },
  {
    id: 2,
    date: -2542590568000,
    content:
      "Rainwater is the chief article of diet at supper.  The bread is two-thirds rainwater, the beefsteak-pie is exceedingly rich in it, and the jam, and the butter, and the salt, and the coffee have all combined with it to make soup."
  },
  {
    id: 3,
    date: -2542489568000,
    content:
      "We made a list of the things to be taken, and a pretty lengthy one it was, before we parted that evening.  The next day, which was Friday, we got them all together, and met in the evening to pack.  We got a big Gladstone for the clothes, and a couple of hampers for the victuals and the cooking utensils.  We moved the table up against the window, piled everything in a heap in the middle of the floor, and sat round and looked at it."
  }
];
