<div align="center">

  <img src="https://github.com/Leon-gos/survly/assets/163224096/734b9bd0-3fc7-4a58-b01e-459056e7ca86" alt="logo" width="150" height="auto" />

  <h1>Survly</h1>
  
  <p>
    This is a mobile application for create survey.
  </p>
  
  
<!-- Badges -->
<p>
  <a href="https://github.com/Leon-gos/survly/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/Leon-gos/survly" alt="contributors" />
  </a>
  <a href="">
    <img src="https://img.shields.io/github/last-commit/Leon-gos/survly" alt="last update" />
  </a>
  <a href="https://github.com/Leon-gos/survly/network/members">
    <img src="https://img.shields.io/github/forks/Leon-gos/survly" alt="forks" />
  </a>
  <a href="https://github.com/Leon-gos/survly/stargazers">
    <img src="https://img.shields.io/github/stars/Leon-gos/survly" alt="stars" />
  </a>
  <a href="https://github.com/Leon-gos/survly/issues/">
    <img src="https://img.shields.io/github/issues/Leon-gos/survly" alt="open issues" />
  </a>
</p>
   
<h4>
    <a href="https://github.com/Leon-gos/survly/">View Demo</a>
  <span> · </span>
    <a href="https://github.com/Leon-gos/survly">Documentation</a>
  <span> · </span>
    <a href="https://github.com/Leon-gos/survly/issues/">Report Bug</a>
  <span> · </span>
    <a href="https://github.com/Leon-gos/survly/issues/">Request Feature</a>
  </h4>
</div>

<br />

<!-- Table of Contents -->
# :notebook_with_decorative_cover: Table of Contents

- [About the Project](#star2-about-the-project)
  * [Screenshots](#camera-screenshots)
  * [Tech Stack](#space_invader-tech-stack)
  * [Features](#dart-features)
  * [Color Reference](#art-color-reference)
  * [Environment Variables](#key-environment-variables)
- [Getting Started](#toolbox-getting-started)
  * [Prerequisites](#bangbang-prerequisites)
  * [Installation](#gear-installation)
  * [Running Tests](#test_tube-running-tests)
  * [Run Locally](#running-run-locally)
  * [Deployment](#triangular_flag_on_post-deployment)
- [Directory Structure](#eyes-directory-structure)
- [Architecture Diagram](#chart-architecture-diagram)
- [Entity Relationship Diagram](#chart-entity-relationship-diagram)
- [Contributing](#wave-contributing)
- [Contact](#handshake-contact)
- [Acknowledgements](#gem-acknowledgements)

<!-- About the Project -->
## :star2: About the Project <a name="star2-about-the-project"></a>


<!-- Screenshots -->
### :camera: Screenshots <a name="camera-screenshots"></a>

|  Sign in | Sign up |
| --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/54bd8c07-8c4a-4fb2-9fd3-cf0cbd14ef4e" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/402632da-c6e8-4a06-b839-2a6366eda529" width=250> |

| Dashboard admin  | Filter sheet | User list |
| --- | --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/5ec92519-dc0d-4c4d-b818-414c680a16a2" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/601dcb7c-ffeb-42a3-8627-11de48abfc60" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/aebc1992-490a-4fb8-ab80-7b8696675b22" width=250> |

| Create survey  |
| --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/74b7073b-0eb2-4029-ac22-08663ed873c5" width=250> |

| Select outlet place  | Search place | Place selected |
| --- | --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/46c8d53b-ffdc-4641-b976-ebf06dc1bdcd" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/0da83bae-4684-4ca6-99a1-168dfc3d085a" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/a6c239ef-45ec-4507-9240-3c9b0ae508ac" width=250> |

| Add text question  | Add optional question | Filled survey form |
| --- | --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/9904215b-9eab-49fb-bb1d-e5785d8e851a" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/3b3ad5a2-95ac-437b-90fb-061548d6b930" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/ca4aa73f-4978-424d-a4a1-0e0d6260968f" width=250> |

| Review survey  | Edit survey |
| --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/cb3db9cf-4157-4a12-9caf-4b02e732d95a" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/becaa00c-26e5-4734-ab8d-aaf5a995136f" width=250> |

| Survey request list  | Response request |
| --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/a5122c64-067d-44b3-b835-eb32d3f30cba" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/8009ea6b-0ee4-4317-9f7f-88f0f86e51e2" width=250> |

| User survey discover  | Survey preview | Request survey |
| --- | --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/7e74d086-9630-4efc-810a-9717450cfc7c" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/8930e382-aa69-45c3-a0b3-90a2166f3e85" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/3360e132-7839-44ed-afcc-a42068cdcc35" width=250> |

| User doing survey list  | Do survey - Intro | Do survey - Outlet |
| --- | --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/3f16bd9c-4fb7-4bbd-bc24-e4ebd52c7f80" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/cb40af84-d48b-4a8f-b425-cdc58ef4d0fe" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/38e5b14f-2745-4418-a480-113a5bf29476" width=250> |

| Do survey - Text question  | Do survey - Single option question | Do survey - Multiple option question |
| --- | --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/2152b911-c248-4bb8-802b-899290a39428" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/ff8d8ff8-f20e-434d-a428-1b053525b002" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/12f5a9b0-c551-4b15-9cf3-44ecaa952998" width=250> |

| Profile  | Update profile |
| --- | --- |
| <img src="https://github.com/Leon-gos/survly/assets/163224096/cc6bcf23-3cc1-4acc-b7cb-bf03109f7333" width=250> | <img src="https://github.com/Leon-gos/survly/assets/163224096/a3db35ed-68ce-4b15-bd1c-f682125f6b14" width=250> |


<!-- TechStack -->
### :space_invader: Tech Stack <a name="space_invader-tech-stack"></a>

<details>
  <summary>Mobile</summary>
  <ul>
    <li><a href="https://dart.dev/">Dart</a></li>
    <li><a href="https://flutter.dev/">Flutter</a></li>
  </ul>
</details>

<details>
  <summary>Serverless</summary>
  <ul>
    <li><a href="https://console.firebase.google.com/">Firebase</a></li>
  </ul>
</details>

<details>
  <summary>Google Map API</summary>
  <ul>
    <li><a href="https://google.com/maps/">Google Map API</a></li>
  </ul>
</details>

<details>
<summary>Database</summary>
  <ul>
    <li><a href="https://console.firebase.google.com/">Firebase FireStore</a></li>
  </ul>
</details>

<details>
<summary>DevOps</summary>
  <ul>
    <li><a href="https://www.gtihub.com/">Github</a></li>
    <li><a href="https://www.gtihub.com/">Github Action</a></li>
    <li><a href="https://fastlane.tools/">Fastlane</a></li>
    <li><a href="https://firebase.google.com/docs/crashlytics/">Firebase Crashlytics</a></li>
  </ul>
</details>

<!-- Features -->
### :dart: Features

- Sign In, Sign Up
- Account management
- Manage survey
- Manage survey request
- Do survey

<!-- Color Reference -->
### :art: Color Reference

| Color             | Hex                                                                |
| ----------------- | ------------------------------------------------------------------ |
| Primary Color | ![#007760](https://via.placeholder.com/10/007760?text=+) #007760 |
| Secondary Color | ![#C08B5C](https://via.placeholder.com/10/C08B5C?text=+) #C08B5C |
| Background Brightness Color | ![#FAFAFA](https://via.placeholder.com/10/FAFAFA?text=+) #FAFAFA |


<!-- Env Variables -->
### :key: Environment Variables

Coming soon

<!-- To run this project, you will need to add the following environment variables to your .env file

`API_KEY`

`FCM_SERVER_KEY` -->

<!-- Getting Started -->
## 	:toolbox: Getting Started

<!-- Prerequisites -->
### :bangbang: Prerequisites

This project uses Fastlane to auto deploy Firebase Distribution. You need to install Fastlane for this project. You need to install the ruby environment before installing Fastlane. Download and install [here](https://rubygems.org)

After installation is complete, run the command below to install Fastlane

```bash
 gem install fastlane
```

<!-- Installation -->
### :gear: Installation

Install all package in project

```bash
  flutter pub get
```

<!-- Run Locally -->
### :running: Run Locally

Clone the project

```bash
  git clone https://github.com/Leon-gos/survly.git
```

Go to the project directory

```bash
  cd survly
```

Install dependencies

```bash
  flutter pub get
```

Set up Multiple Language

```bash
  flutter gen-l10n
```

Start the project

```bash
  flutter run
```


<!-- Deployment -->
### :triangular_flag_on_post: Deployment

To deploy this project to Firebase Distribution

```bash
  fastlane firebase
```

<!-- Directory structure -->
## :eyes: Directory Structure

```bash
survly
├───android
├───assets
│   ├───fonts
│   └───images
│   └───svgs
├───ios
├───lib
│   ├───gen
│   └───l10n
│   └───src
│   │   ├───config
│   │   │  ├───constants
│   │   │       ├───firebase_collections
│   │   │       └───notification
│   │   │       └───timeout
│   │   └───features
│   │   │   ├───admin_profile
│   │   │   └───authentication
│   │   │   └───create_survey
│   │   │   └───dashboard
│   │   │   └───dashboard_admin
│   │   │   └───dashboard_user
│   │   │   └───do_survey
│   │   │   └───do_survey_review
│   │   │   └───do_survey_tracking
│   │   │   └───my_profile
│   │   │   └───preview_survey
│   │   │   └───response_user_survey
│   │   │   └───review_survey
│   │   │   └───select_location
│   │   │   └───survey_request
│   │   │   └───survey_response
│   │   │   └───update_admin_profile
│   │   │   └───update_survey
│   │   │   └───update_user_profile
│   │   │   └───user_profile
│   │   └───local
│   │   │   ├───model
│   │   │   └───secure_storage
│   │   │   │   ├───userbase_singleton
│   │   │   │   └───authentication_repository
│   │   └───localization
│   │   └───network
│   │   │   ├───data
│   │   │   │   ├───repositories
│   │   │   └───model
│   │   └───router
│   │   │   ├───coordinator
│   │   │   └───router_name
│   │   │   └───router
│   │   └───service
│   │   │   ├───notification
│   │   │   └───permission
│   │   │   └───picker
│   │   └───theme
│   │   └───utils
│   │   │   ├───coordinate
│   │   │   └───date
│   │   │   └───debound
│   │   │   └───file
│   │   │   └───map
│   │   │   └───number
│   │   └───app.dart
│   │   └───domain_manager.dart
│   │   └───locator.dart
│   └───widgets
│   └───firebase_options.dart
│   └───main.dart
├───linux
├───macos
├───screenshots
├───test
├───web
└───windows
└───.env
```

<!-- Architecture Diagram -->
## :chart: Architecture Diagram

<img src="https://github.com/Leon-gos/survly/assets/163224096/4fce7c0a-5d32-4ad8-84c5-0ed49a42a3c9">

<!-- Entity Relationship Diagram -->
## :chart: Entity Relationship Diagram

<img src="https://github.com/Leon-gos/survly/assets/163224096/2c4a42e4-4928-45d7-973b-f8df5a132eaf">

<!-- Contributing -->
## :wave: Contributing

<a href="https://github.com/Leon-gos/survly/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Leon-gos/survly" />
</a>

Contributions are always welcome!

<!-- Contact -->
## :handshake: Contact

Leon Nguyen - leon.nguyen.gos@gmail.com

Project Link: [https://github.com/Leon-gos/survly](https://github.com/Leon-gos/survly)


<!-- Acknowledgments -->
## :gem: Acknowledgements
In Survly project, I used some useful resources and libraries to aid the development process.

 - [Firebase and related packages](https://firebase.google.com/)
 - [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
 - [GoRouter](https://pub.dev/packages/go_router)
 - [GetIt](https://pub.dev/packages/get_it)
 - [Google Map for Flutter](https://pub.dev/packages/google_maps_flutter)
 - [Location](https://pub.dev/packages/location)
 - [Flutter SVG](https://pub.dev/packages/flutter_svg)
 - [Formz](https://pub.dev/packages/formz)
 - [Flutter secure storage](https://pub.dev/packages/flutter_secure_storage)
 - [Logger](https://pub.dev/packages/logger)
 - [ImagePicker](https://pub.dev/packages/image_picker)
 - [Http](https://pub.dev/packages/http)
 - [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)
 - [Permission handler](https://pub.dev/packages/permission_handler)
