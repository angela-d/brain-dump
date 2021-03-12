# Custom Bookmarks via Firefox GPO
This GPO isn't as straightforward as with Chrome/Edge, as there appears to be a legacy Bookmark object, too. (Ignore the **Bookmarks** object, with the list of 50 bookmarks; use the *Managed Bookmarks* GPO referenced below.)

Objective:
- Bookmarks folder in the bookmark toolbar
- Ensure it shows by default (bookmarks toolbar is hidden by default)

## Enable the Bookmarks Toolbar
Turn on the bookmarks toolbar, by default:
- User Configuration > Administrative Templates > Mozilla > Firefox > Display Bookmarks Toolbar
  - [x] Enabled

## Hide Default Bookmarks
Mozilla's "Getting Started" and "Most Visited" folder
- User Configuration > Administrative Templates > Mozilla > Firefox > No Default Bookmarks
  - [x] Enabled

## Set Your Custom Bookmarks
- User Configuration > Administrative Templates > Mozilla > Firefox > Managed Bookmarks
  - [x] Enabled
  - Option:
  ```json
  [
    {
      "toplevel_name": "Company Resources"
    },
    {
      "url": "https://example.com",
      "name": "Company Portal"
    },
    {
      "name": "IT Helpdesk",
      "children": [
        {
          "url": "https://announce.example.com",
          "name": "IT Announcements"
        },
        {
          "url": "https://tickets.example.com",
          "name": "Open a Ticket"
        }
      ]
    }
  ]
  ```
