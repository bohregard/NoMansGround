using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.EventSystems;

public class RM_Controls : MonoBehaviour {

    public EventSystem es;
    public GameObject button;

    public void Start()
    {
        es.SetSelectedGameObject(button);
    }

    public void Play()
    {
        SceneManager.LoadScene("Level 1");
    }

    public void Back()
    {
        SceneManager.LoadScene("MainMenu");
    }

    public void Quit()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
		Application.Quit ();
#endif
    }
}
