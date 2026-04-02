#import "/src/lib.typ" as my-package

#my-package.todo(text: "backend: Add API")
#my-package.todo(text: "frontend: Build screen")
#my-package.todo(text: "backend: Add tests")
#my-package.todo(text: "Write changelog")
#my-package.todo(text: "frontend: Ship polish", state: my-package.TodoState.Complete)
#my-package.todo(text: "ops: Remove legacy job", state: my-package.TodoState.Abandoned)

#my-package.todo-list()
