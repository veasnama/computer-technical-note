## What is a state in flutter ? 

- Flutter is declarative. This means that Flutter builds its user interface to reflect the current state of your app

- Formual
```
    UI = F  ( State )
```
- UI - The layout on the screen
- F - Your build method 
- State - Our Application state 

- <b> State </b> can be described as "whatever data you need in order to rebuild your UI at any moment in time"

- When the state of your app changes (for example, the user flips a switch in the settings screen), you change the state, and that triggers a redraw of the user interface. There is no imperative changing of the UI itself (like widget.setText)—you change the state, and the UI rebuilds from scratch

- The state that you do manage yourself can be separated into two conceptual types: ephemeral(widget state on your question) state and app state

- <b> Ephemeral state </b>
- Ephemeral state (sometimes called UI state or local state) is the state you can neatly contain in a single widge

- There is no need to use state management techniques (ScopedModel, Redux, Provider, bloc, etc.) on this kind of state. All you need is a StatefulWidget. You only need to use setState to alter your current state
- For example, below, you see how the currently selected item in a bottom navigation bar is held in the _index field of the _MyHomepageState class. In this example, _index is ephemeral state.


```
    class MyHomepage extends StatefulWidget {
    const MyHomepage({Key? key}) : super(key: key);

    @override
    _MyHomepageState createState() => _MyHomepageState();
    }

    class _MyHomepageState extends State<MyHomepage> {
    int _index = 0;

    @override
    Widget build(BuildContext context) {
        return BottomNavigationBar(
        currentIndex: _index,
        onTap: (newIndex) {
            setState(() {
            _index = newIndex;
            });
        },
        // ... items ...
        );
    }
    }

```
- Here, using setState() and a field inside the StatefulWidget’s State class is completely natural. No other part of your app needs to access _index. The variable only changes inside the MyHomepage widget. And, if the user closes and restarts the app, you don’t mind that _index resets to zero
- <b> App State </b>

- State that is not ephemeral, that you want to share across many parts of your app, and that you want to keep between user sessions, is what we call application state (sometimes also called shared state)
- <b> Examples of application state </b>
- User preferences
- Login info
- Notifications in a social networking app
- The shopping cart in an e-commerce app
- Read/unread state of articles in a news app

- For managing app state, you’ll want to research your options. Your choice depends on the complexity and nature of your app, your team’s previous experience, and many other aspects.

Here's a link to an example on app wide state management using provider(one of many state  management libraries ) [Example](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple)

- Here's a list of libraries that are used for app wide state management [Options](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)