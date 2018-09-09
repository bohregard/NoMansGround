using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameManager : Singleton<GameManager>
{

    public GameObject[] players;
    public Text[] playerTexts;
    public GameObject[] spawns;
    public float timer;
    public Text timerUI;
    private bool timerStart = false;
    private bool timerEnd = false;

    // Use this for initialization
    void Start()
    {
        StartTimer();
        Debug.Log("Loading");
        Debug.Log(spawns.Length + " spawns");
        /*
        foreach (GameObject item in players)
        {
            System.Random rand = new System.Random();
            var index = rand.Next(spawns.Length);
            item.transform.position = spawns[index].transform.position;
        }
        */
        players[0].transform.position = spawns[0].transform.position;
        players[1].transform.position = spawns[1].transform.position;
        players[2].transform.position = spawns[2].transform.position;
        players[3].transform.position = spawns[3].transform.position;
    }

    void StartTimer()
    {
        timerStart = true;
    }

    void EndGame()
    {
        Player winningPlayer = null;
        int score = -1;
        bool tie = false;
        Time.timeScale = .3f;
        for (int i = 0; i < players.Length; i++)
        {
            Player stats = players[i].GetComponent<Player>();
            if (stats.kills > score)
            {
                tie = false;
                winningPlayer = stats;
            }
            else if (stats.kills == score)
            {
                tie = true;
            }
        }

        if (tie)
        {
            timerUI.text = "TIE!";
        }
        else
        {
            timerUI.text = winningPlayer.name;
        }
        StartCoroutine(BackToMenu());
    }

    public IEnumerator BackToMenu()
    {
        yield return new WaitForSeconds(1.1f);
        SceneManager.LoadScene("MainMenu");
    }

    // Update is called once per frame
    void Update()
    {
        if (timerStart && !timerEnd)
        {
            timer -= Time.deltaTime;
            timerUI.text = Mathf.FloorToInt(timer + 1).ToString();
            if (timer <= 0)
            {
                timerEnd = true;
                EndGame();
            }

        }

        for (var i = 0; i < 4; i++)
        {
            playerTexts[i].text = "Health: " + players[i].GetComponent<Health>().HP;
            if(players[i].GetComponent<Health>().HP <= 0)
            {
                playerTexts[i].text = "Respawning";
            }
        }
        /*
        if (Input.GetKeyDown(KeyCode.P))
        {
            for (var i = 0; i < 4; i++)
            {
                players[i].GetComponent<Health>().HP = 0; 
            }
        }
        */
    }
}
