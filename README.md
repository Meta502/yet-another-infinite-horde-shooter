# UAS Game Development - Adrian Ardizza - 2006524896
## Cheat Codes
Cheats can be used to make the game easier to play by modifying the player's current stats. Cheats can be activated/deactivated by pressing a sequence of arrow keys in quick succession:
- U corresponds to ARROW UP
- D corresponds to ARROW DOWN
- L corresponds to ARROW LEFT
- R corresponds to ARROW RIGHT

There are 3 cheat codes available:
### KONAMI_CODE
**Effects:** +5 MAX HEALTH, +2 SHOTGUN PROJECTILES

**Activation/Deactivation:** UUDDLRLRDU

### I_AM_SPEED
**Effects:** +10 SPEED UP

**Activation/Deactivation:** UUDDUUDD

### EAT_LEAD
**Effects:** +3 SHOTGUN PROJECTILES

**Activation/Deactivation:** LLLRRRLL

## Game Polishing
The following is a list of actions taken to polish the game
### Implement Release CI/CD
#### Description
Implemented in the `uas` branch is a GitHub Actions CI/CD workflow that automatically builds a release application for Windows and Linux.

#### Justification
Having an automated workflow that builds and uploads the release version of the game to an artifact can help make the release process easier, along with making it easier for the developers to identify failing builds/commits.