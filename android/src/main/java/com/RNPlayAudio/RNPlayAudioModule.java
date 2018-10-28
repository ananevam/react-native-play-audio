package com.RNPlayAudio;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import android.media.MediaPlayer;
import android.media.AudioManager;
import java.io.IOException;
import android.util.Log;

import android.net.Uri;

public class RNPlayAudioModule extends ReactContextBaseJavaModule {
    Callback onEnd;
    MediaPlayer mediaPlayer;

    public RNPlayAudioModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void prepare(String url, final Callback onReady) {
        
        if (mediaPlayer != null) {
            mediaPlayer.reset();
        }
        
        mediaPlayer = new MediaPlayer();

        mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            public void onCompletion(MediaPlayer mp) {
                if (onEnd != null) {
                    onEnd.invoke();
                }
            }
        });
        mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            public void onPrepared(MediaPlayer mp) {
                if (onReady != null) {
                    onReady.invoke();
                }
            }
        });

        mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
        try {
            mediaPlayer.setDataSource(url);
            mediaPlayer.prepareAsync();
        } catch(IOException e) {
            Log.e("RNPlayAudio", "Exception", e);
        }
    }

    @ReactMethod
    public void prepareWithFile(String name, String type, final Callback onReady) {
        
        if (mediaPlayer != null) {
            mediaPlayer.reset();
        }
        
        mediaPlayer = new MediaPlayer();

        mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            public void onCompletion(MediaPlayer mp) {
                if (onEnd != null) {
                    onEnd.invoke();
                }
            }
        });
        mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            public void onPrepared(MediaPlayer mp) {
                if (onReady != null) {
                    onReady.invoke();
                }
            }
        });

        mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
        try {
            Uri uri = Uri.parse("android.resource://" + getReactApplicationContext().getPackageName() + "/raw/" + name);
            mediaPlayer.setDataSource(getCurrentActivity(), uri);
            mediaPlayer.prepareAsync();
        } catch(IOException e) {
            Log.e("RNPlayAudio", "Exception", e);
        }
    }

    @ReactMethod
    public void play() {
        mediaPlayer.start();
    }

    @ReactMethod
    public void onEnd(Callback callback) {
        onEnd = callback;
    }

    @ReactMethod
    public void getDuration(Callback callback) {
        if (mediaPlayer != null) {
            callback.invoke(mediaPlayer.getDuration() * .001);
        }
    }

    @ReactMethod
    public void getCurrentTime(Callback callback) {
        if (mediaPlayer != null) {
            callback.invoke(mediaPlayer.getCurrentPosition() * .001);
        }
    }

    @ReactMethod
    public void stop() {
        if (mediaPlayer != null) {
            mediaPlayer.stop();
        }
    }

    @ReactMethod
    public void pause() {
        if (mediaPlayer != null) {
            mediaPlayer.pause();
        }
    }

    @ReactMethod
    public void setTime(Float seconds) {
        if (mediaPlayer != null) {
            mediaPlayer.seekTo((int) Math.round(seconds * 1000));
        }
    }

    @ReactMethod
    public void setVolume(Float volume) {
        if (mediaPlayer != null) {
            mediaPlayer.setVolume(volume, volume);
        }
    }

    @Override
    public String getName() {
        return "RNPlayAudio";
    }
}
