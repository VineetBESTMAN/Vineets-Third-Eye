# Vineet's Third Eye — quick operator guide

**GOD IS WATCHING EVERYTHING**

Open <http://localhost:4173>. If it is not running, double-click `start-windows.cmd`. Refresh an existing tab after an application update.

## Start exploring

1. Choose **Explore Manually** on the welcome screen for an empty starting view, or **Live Contacts** for a flight-focused starting setup.
2. Open **LOCATION** at the bottom and search for a city, airport, or coordinates. For example, `28.5562, 77.1000` takes you near Delhi airport; coordinates work without a geocoding key.
3. Drag the globe to move and use the mouse wheel to zoom. Zoom out to see regional activity; zoom in after selecting a contact.
4. Expand **DATA LAYERS** on the left. Its switches control what appears on the globe. Several layers can be enabled together.
5. Click a visible contact to select/track it and read its information card. Click empty globe space or press **Esc** to release tracking (Esc first closes an open dialog if one is active).

## Flights

- Enable **Live Flights**. Enable **Military Flights** separately if desired.
- Move to an airport or populated region and zoom out enough to see nearby airspace. Allow the feed to load and check its count/status.
- Click an aircraft for the available callsign, altitude, speed, heading and other metadata. Its trail and follow camera help track its movement.
- Use **COCKPIT** on a selected aircraft to follow it from the cockpit perspective; this is a rendered view, not a camera onboard the actual plane.
- Use the **3D** aircraft control in **DISPLAY** for models when close enough.
- Anonymous OpenSky and the supported ADS-B fallback can work without your own key. Rate limits, receiver coverage and missing transponder data mean not every aircraft appears. A military label does not imply complete military coverage.

## Ships

1. Open **POWER UP** at the bottom right to enter **Provider Settings**. If the chip is hidden, visit <http://localhost:4173/?setup=1>.
2. Obtain your own AISStream API key from <https://aisstream.io>.
3. Paste it into the **AISStream** field and click **SAVE KEYS**. The app reloads/restarts its configuration. Do not share the key or commit it to Git.
4. Expand **DATA LAYERS** and enable **Live Vessels**.
5. Move to a busy port or shipping lane (for example, Singapore or the English Channel), zoom out, and allow incoming AIS messages to populate the view.
6. Click a ship to see available identity, course, speed and vessel information, plus its tracked movement/trail.

Without an AISStream key this layer cannot provide the live ship stream. Even with a key, coverage and message freshness vary. The local environment variable is `AISSTREAM_API_KEY`; Provider Settings writes credentials to ignored local configuration.

## Satellites

- Enable **Satellites**, then zoom out to see Earth and the orbits around it.
- Use its class switches: **STATIONS**, **IMAGING**, **TELECOM**, **STARLINK**, **PROBES**, and **DEBRIS**.
- Start with **STATIONS** to find the ISS and other station-related objects. Select a satellite to inspect its available identity/orbit information and follow it.
- **STARLINK** loads thousands of extra points and can take longer or reduce rendering performance. Leave it off until needed.
- This layer uses public CelesTrak orbital elements and calculated positions. It is satellite tracking, not a live video feed from those satellites. The **IMAGING** class identifies Earth-observation satellites; selecting one does not give access to its camera.

## When a layer looks empty

Check that its switch is on, wait for loading, expand your map view, and inspect the layer's status. For ships, verify the AISStream key. For flights/satellites, public providers can be unavailable or rate-limited. Keep fewer layers enabled if the globe becomes slow. Reload the page if a provider has recovered but the view has not.

The imagery under the contacts is a basemap, not a real-time overhead camera. Traffic simulation and calculated satellite positions should not be confused with live visual observations.

## Other documentation

- [Windows setup and launch guide](LOCAL-WINDOWS.md)
- [Initial setup validation](LOCAL-VALIDATION.md)
- [Upstream data-source inventory](DATA_SOURCES.md)

This personalized edition is based on Bilawal Sidhu's God's Eye View. Original code and data attribution remain in `LICENSE` and `THIRD_PARTY_NOTICES.md`.
