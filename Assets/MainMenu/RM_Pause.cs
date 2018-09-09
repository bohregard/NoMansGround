using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class RM_Pause : MonoBehaviour {
    //Puase Menu
    public GameObject pause;
    private bool paused = false;
    public GameObject pauseMenu;
    public GameObject controlsMenu;
    private GameObject Player;
    public bool LeavingScene = false;



    //Start
    void Start()
    {
        //pauseMenu = GameObject.Find("Pause Menu");
        //controlsMenu = GameObject.Find("Controls Menu");
        Player = FindObjectOfType<Player>().gameObject;
        pause.SetActive(false);
        controlsMenu.SetActive(false);

    }

    //Update
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Pause();
        }


    }

    //Pause Buttons
    public void Pause()
    {

        paused = !paused;
        if (paused)
        {
            pause.SetActive(true);
            PauseMenu();
            Time.timeScale = 0;
            Player.GetComponent<Player>().enabled = false;
          
        }

        if (!paused)
        {
            pause.SetActive(false);
            Time.timeScale = 1;
            Player.GetComponent<Player>().enabled = true;
        }
    }

    public void MainMenu()
    {
        Time.timeScale = 1;
        LeavingScene = true;
        SceneManager.LoadScene("MainMenu");

    }

    public void PauseMenu()
    {
        pauseMenu.SetActive(true);
        controlsMenu.SetActive(false);
    }

   

    public void ControlsMenu()
    {
        pauseMenu.SetActive(false);
      
        controlsMenu.SetActive(true);
 
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
