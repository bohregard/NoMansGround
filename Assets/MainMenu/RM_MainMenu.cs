using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class RM_MainMenu : MonoBehaviour {

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

    public void Controls()
    {
        SceneManager.LoadScene("Controls");
    }

    public void Credits()
    {
        SceneManager.LoadScene("Credits");
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
