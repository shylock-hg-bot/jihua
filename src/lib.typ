// todo.typ - A simple TODO package for Typst
// Place this in your project or in ~/.typst/packages/local/todo:0.1.0/init.typ
// Usage: #import "@local/todo:0.1.0": todo, todo-list


#let TodoState = (
  Pending: "Pending",
  Complete: "Complete",
  Abandoned: "Abandoned"
)

#let __todo-state(state) = {
  if not (state in TodoState.values()) {
    error("Invalid state: " + state)
  }
  state
}

#let __todo-list = state("todo-items", ())

#let __todo-item(text, state) = {
  let separator = ": "
  let split-at = text.position(separator)

  if split-at == none {
    (group: none, txt: text, state: __todo-state(state))
  } else {
    let group = text.slice(0, split-at)
    let body = text.slice(split-at + separator.len())

    if group == "" or body == "" {
      (group: none, txt: text, state: __todo-state(state))
    } else {
      (group: group, txt: body, state: __todo-state(state))
    }
  }
}

#let __todo-groups(items) = {
  let groups = ()

  for item in items {
    if not (item.group in groups) {
      groups.push(item.group)
    }
  }

  groups
}

#let __render-todo-group(items) = {
  let texts = items.map(item => item.txt)
  set enum(numbering: "1.a)")
  enum(..texts)
}

#let __render-todo-list(items, empty, strike-items: false) = {
  if items.len() == 0 {
    [#empty]
  } else {
    for group in __todo-groups(items) {
      let grouped = items.filter(item => item.group == group)
      let content = if strike-items {
        strike(__render-todo-group(grouped))
      } else {
        __render-todo-group(grouped)
      }

      if group == none {
        content
      } else {
        [
          #heading(level: 2, text(fill: green, group))
          #content
        ]
      }
    }
  }
}

// Function to add a TODO note
#let todo(
  text: "TODO: Implement this",
  show-in-list: true,
  state: TodoState.Pending
) = {
  // If show-in-list, add to global state for later listing
  if show-in-list {
    __todo-list.update(items => {
      items.push(__todo-item(text, state))
      items
    })
  }
}

// Function to display all collected TODOs as a list at the end of the document
#let todo-list(
  title: "Pending TODO Items",
  complete-title: "Completed TODO Items",
  abondon-title: "Abondoned TODO Ttems"
) = {
  context {
    let items = __todo-list.final()
    let complete = items.filter(item => item.state == TodoState.Complete)
    let pending = items.filter(item => item.state == TodoState.Pending)
    let abondon = items.filter(item => item.state == TodoState.Abandoned)

    heading(level: 1, title)
    __render-todo-list(pending, "No TODO items found.")

    heading(level: 1, complete-title)
    __render-todo-list(complete, "No TODO items found.", strike-items: true)

    heading(level: 1, abondon-title)
    __render-todo-list(abondon, "No TODO items found.", strike-items: true)
  }
}
