using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour {

    private static AudioSource sfxSource;

	// Use this for initialization
	void Start () {
        sfxSource = GameObject.FindGameObjectWithTag("SFX").GetComponent<AudioSource>();
	}

    static public IEnumerator PlaySoundEffect(AudioClip soundEffect)
    {
        sfxSource.PlayOneShot(soundEffect, sfxSource.volume);
        yield return null;
    }
}
