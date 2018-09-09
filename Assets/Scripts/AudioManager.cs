using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour {

    private static AudioSource audioSource;

	// Use this for initialization
	void Start () {
        audioSource = FindObjectOfType<AudioSource>().GetComponent<AudioSource>();
	}

    static public IEnumerator PlaySoundEffect(AudioClip soundEffect)
    {
        audioSource.PlayOneShot(soundEffect, audioSource.volume);
        yield return null;
    }
}
