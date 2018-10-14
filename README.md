
# react-native-play-audio

## Getting started

`$ npm install react-native-play-audio --save`

### Mostly automatic installation

`$ react-native link react-native-play-audio`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-play-audio` and add `RNPlayAudio.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNPlayAudio.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.RNPlayAudio.RNPlayAudioPackage;` to the imports at the top of the file
  - Add `new RNPlayAudioPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-play-audio'
  	project(':react-native-play-audio').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-play-audio/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-play-audio')
  	```
## Usage
```javascript
import AudioPlayer from 'react-native-play-audio';

AudioPlayer.onEnd(() => {
  console.log('on end');
});

const URL = 'http://sample.com/sample.mp3';

const callback = () => {
  AudioPlayer.play();
    
  AudioPlayer.getDuration((duration) => {
    console.log(duration);
  });
  setInterval(() => {
    AudioPlayer.getCurrentTime((currentTime) => {
      console.log(currentTime);
    });
  }, 1000);
}

AudioPlayer.prepare(URL, callback);
AudioPlayer.prepareWithFile('sample', 'mp3', callback);

// AudioPlayer.stop();
// AudioPlayer.pause();
// AudioPlayer.setTime(50.5);

#### What is new in version 0.2

- Added ability to load local files
- Fixed main_queue warning
- Increased react-native version in package.json
- Updated this README.md file