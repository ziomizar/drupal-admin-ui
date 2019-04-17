# Drupal Admin UI

[![Greenkeeper badge](https://badges.greenkeeper.io/jsdrupal/drupal-admin-ui.svg)](https://greenkeeper.io/)

This is an admin UI for Drupal, built with JavaScript and based on [create-react-app](https://github.com/facebook/create-react-app).

- [Drupal Admin UI](#drupal-admin-ui)
  * [Installation](#installation)
    + [Requirements](#requirements)
    + [Steps](#steps)
  * [Running](#running)
  * [Developing](#developing)
    + [tl;dr](#tldr)
  * [Development guidelines](#development-guidelines)
  * [Commands](#commands)
  * [Contributing to This Repository](#contributing-to-this-repository)
  * [Extension Points Bundler](#extension-points-bundler)

## Requirements

- Node >= 10 (we recommend using https://github.com/creationix/nvm)
- Yarn >= 1.15
- [Docker](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/),
  or you can setup Drupal manually. See the `Makefile` for guidance.
- [Lando](https://docs.devwithlando.io/installation/system-requirements.html)  

## Installation

### Drupal

Ensure that you currently have nothing running on port 3000 (e.g. a local node process). You can run ` lsof -i :80 -S` to see what you currently have running.

```
git clone git@github.com:jsdrupal/drupal-admin-ui.git
cd drupal-admin-ui
lando start
```

You can see now all the urls generated, which are the URL that the node container sees Drupal on internally. 

If this fails and you see `Killed` from composer, you will need to [increase your memory allocation](https://docs.docker.com/docker-for-mac/#advanced) for Docker.

You can run your Drupal commands inside the container (e.g. `lando drush status`). you can runn `lando` to see all the available commands.

Open the one time login link in your browser to log into Drupal. You will then have the following available:

| URL | Description |
|---|---|
| http://drupal-admin-ui.lndo.site  | Regular Drupal installation / JSON API endpoints |
| http://drupal-admin-ui.lndo.site/admin/content | A page taken over by the new admin UI. This uses the bundled version from `packages/admin-ui/build`, run `yarn workspace admin-ui build` in the node container to re-build |

### Admin UI

`lando admin-ui-start` will start the Webpack dev sever that comes with [Create React App](https://facebook.github.io/create-react-app).

#### Nightwatch
- If you don't know the password for admin, change it with `lando drush user:password admin admin`
- Run `lando yarn workspace admin-ui build`
- Run `lando -e NIGHTWATCH_LOGIN_admin_PASSWORD=admin drupal_admin_ui_node yarn workspace admin-ui nightwatch`
or `lando -e NIGHTWATCH_LOGIN_admin_PASSWORD=admin drupal_admin_ui_node yarn test` to run all tests
- When you're finished, restore the regular build if you want to browse the compiled version in your browser with `lando yarn workspace admin-ui build`.
This will also be restored when you restart your containers.

#### React AXE

Due to outstanding performance issues, `react-axe` is behind a flag. To enable the assessment provided by `react-axe`, pass an environment variable when starting the application.

```
REACT_APP_AXE=true yarn workspace @drupal/admin-ui start
```

## Development guidelines

### Testing

We have functional testing with [Nightwatch](http://nightwatchjs.org/), and component/unit testing with [Jest](https://jestjs.io/).

When deciding which system to use to add test coverage, the general rule is Nightwatch should be used to test the common path, and Jest can be used for more detailed test coverage. Nightwatch tests will run slower as they simulate clicking around in a real browser.

## Contributing to This Repository

- [Fork this repo](https://help.github.com/articles/fork-a-repo/) to your own user
- Set your fork as origin, and this repo as upstream. From inside the `drupal-admin-ui` folder:
  ```
  git remote rm origin
  git remote add origin git@github.com:<your-username>/drupal-admin-ui.git
  git remote add upstream git@github.com:jsdrupal/drupal-admin-ui.git
  ```
- Make your proposed changes on a [branch](https://guides.github.com/activities/hello-world/#branch) and then push them to your fork
  ```
  git push origin <your-branch>
  ```
- [Make a pull request](https://help.github.com/articles/about-pull-requests/)!
- Switch back to master and pull in the latest changes
  ```
  git checkout master
  git pull upstream master
  ```
- Our [issue queue](https://github.com/jsdrupal/drupal-admin-ui/issues) is public and you already have the required permissions to participate. However in order to perform administrative tasks, such as assigning issues or editing labels, make a request in #javascript in [Drupal Slack](https://www.drupal.org/slack) to be added as a member of the [Contributors Team](https://github.com/orgs/jsdrupal/teams/contributors)

If someone has made a pull request and you would like to add code to their branch, there are a number of ways to move forward. It will be very helpful to get familiar with [managing remotes](https://help.github.com/categories/managing-remotes/) in Git.

- First, ping them in #javascript to discuss the addition/changes!
- Once agreed, you can make a pull request to their fork/branch, which once accepted will appear in the pull request to the main jsdrupal/drupal-admin-ui repo
- Alternatively, they could give you access to modify their branch directly at `https://github.com/<username>/drupal-admin-ui/settings/collaboration` (although bear in mind this will give access to their entire repository fork)
- If you're unable to agree, or unable to get in touch with the author, you could create a new pull request that incorporates the work from their branch

  ```
  git remote add <their-username> git@github.com:<their-username>/drupal-admin-ui.git
  git fetch <their-username>
  git checkout -b <branch-name> <their-username>/<branch-name>
  .
  . work, commit things, etc
  .
  git push <your-fork> <branch-name>
  ```
## Extension Points Bundler

See the documentation in `packages/extension-points` for how this tooling works.
