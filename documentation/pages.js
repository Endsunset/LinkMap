// Hand-maintained content for the two migrated pages. No generation step.
const documentationPages = {
  "ios": {
    "title": "LinkMap for iOS",
    "summary": "Plan places, activities, and team assignments with the LinkMap iOS app.",
    "kind": "overview",
    "sections": [
      {
        "title": "Start with your project",
        "body": "Start on the Map, choose your Project, Activity, and Assignment in Context, and use Project Detail to plan and manage your work.",
        "points": []
      }
    ],
    "action": {
      "title": "Download LinkMap for iOS",
      "href": "../../download/"
    }
  },
  "how-linkmap-works": {
    "title": "How LinkMap Works",
    "summary": "LinkMap opens on the Map. Choose a Project to see shared places, then select an Activity and Assignment for the work you are doing.",
    "kind": "article",
    "group": "Introduction",
    "sections": [
      {
        "title": "The Main Loop",
        "body": "After launch, LinkMap opens on the Map, with Settings available in a separate tab. Use More (…) → Context to choose a Project, then an Activity and optional Assignment. Projects hold reusable places and resources; Activities organize specific rounds of work. Open Project Detail from the Map menu to manage that setup, then return to the Map to follow routes and log work.",
        "points": []
      },
      {
        "title": "What Comes First",
        "body": null,
        "points": [
          "From the Map, use More (…) → Add Project to create a Project, or Scan to join a shared one. Use Context to select the Project you want to work with.",
          "Build the Project map with Regions, Layers, and Locations so the team has a shared view of where work happens.",
          "Add Items for reusable resources such as supplies, equipment, materials, or packages.",
          "Create an Activity only when you are ready to plan a specific round of work.",
          "Inside the Activity, create Routes, Stops, Assignments, and Supplies to turn the Project setup into a plan.",
          "During the Activity, use the Map and dashboard to log what happened, then review reports before archiving."
        ]
      },
      {
        "title": "Why Projects and Activities Are Separate",
        "body": "Project setup should last longer than one day of work. A Location or Item may be useful across many Activities, while a Route, Assignment, Supply list, or Distribution usually belongs to one Activity. Keeping these parts separate lets each new Activity reuse the same map and resources without rewriting the Project from scratch.",
        "points": []
      },
      {
        "title": "A Practical Way to Think About It",
        "body": null,
        "points": [
          "Project answers: where are we working, what places matter, and what resources exist?",
          "Activity answers: what are we doing this time, who is doing it, where do they go, and what should they carry?",
          "Logging answers: what actually happened, at which stop, and with which items?",
          "Reports answer: what should be shared or reviewed after the work is done?"
        ]
      }
    ],
    "next": {
      "slug": "basic-workflow",
      "title": "Basic Workflow Example"
    }
  }
};

// Navigation metadata also supplies the iOS overview cards. Unmigrated articles stay in docs/.
const documentationNavigation = [
  {
    "slug": "how-linkmap-works",
    "title": "How LinkMap Works",
    "summary": "LinkMap opens on the Map. Choose a Project to see shared places, then select an Activity and Assignment for the work you are doing.",
    "group": "Introduction"
  },
  {
    "slug": "basic-workflow",
    "title": "Basic Workflow Example",
    "summary": "This example follows one Project from setup through a completed Activity.",
    "group": "Introduction",
    "parent": "how-linkmap-works"
  },
  {
    "slug": "project",
    "title": "Project",
    "summary": "A Project is the top-level workspace. It contains the map, Items, Activities, collaboration, and work history.",
    "group": "Features"
  },
  {
    "slug": "map",
    "title": "Map",
    "summary": "The Map is LinkMap’s launch screen and the main place to choose a work context, explore places, follow routes, and log activity.",
    "group": "Features"
  },
  {
    "slug": "regions-and-layers",
    "title": "Regions and Layers",
    "summary": "Regions and Layers organize large or vertical maps within a selected Project. Select a Project before viewing or managing its Regions and Layers.",
    "group": "Features",
    "parent": "map"
  },
  {
    "slug": "locations",
    "title": "Locations",
    "summary": "Locations are reusable places on the Project map. Select a Project before viewing or managing its Locations. Activities use them later as route stops and logging points.",
    "group": "Features",
    "parent": "map"
  },
  {
    "slug": "items",
    "title": "Items",
    "summary": "Items are the reusable resources a Project plans with and records during work.",
    "group": "Features",
    "parent": "project"
  },
  {
    "slug": "activities",
    "title": "Activities",
    "summary": "An Activity is one planned cycle of work inside a Project.",
    "group": "Features",
    "parent": "project"
  },
  {
    "slug": "routes-and-stops",
    "title": "Routes and Stops",
    "summary": "Routes turn Project Locations into an ordered plan. Stops are the individual places in that order.",
    "group": "Features",
    "parent": "activities"
  },
  {
    "slug": "assignments-and-supplies",
    "title": "Assignments and Supplies",
    "summary": "Assignments define who does the work. Supplies define what they plan to carry, use, or deliver.",
    "group": "Features",
    "parent": "activities"
  },
  {
    "slug": "logging-and-reports",
    "title": "Logging and Reports",
    "summary": "Logging captures what happened during an Activity. Reports turn the plan and results into reviewable text.",
    "group": "Features",
    "parent": "activities"
  },
  {
    "slug": "sharing",
    "title": "Sharing",
    "summary": "Sharing lets other people open and work from the same Project.",
    "group": "Sharing"
  }
];
const documentationVersion = "LinkMap 3.0.0 Beta 8";

const documentationPlatforms = [{ slug: "web", title: "Web" }, { slug: "ios", title: "iOS" }];
